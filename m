Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZG2IZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZG2IZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZG2IZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:25:49 -0400
Received: from mail.open.by ([193.232.92.17]:60597 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZG2IZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:25:47 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9186 [Jul 29 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Wed, 29 Jul 2009 11:28:26 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: James Morris <jmorris@namei.org>
Cc: Miloslav Trmac <mitr@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: BUG: scheduling while atomic reintroduced
Message-ID: <20090729082826.GA3208@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
who is tty maintainer at the moment?

kernel: [30720.827764] BUG: soft lockup - CPU#1 stuck for 61s! [pppd:3132]
kernel: [30720.827766] Modules linked in: ppp_async crc_ccitt ppp_generic s=
lhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel=
 snd_hda_codec snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_devic=
e psmouse snd i2c_i801 serio_raw rng_core pcspkr soundcore snd_page_alloc a=
sus_laptop evdev usbhid hid
sg sd_mod sr_mod cdrom ata_generic pata_acpi ata_piix sdhci_pci ricoh_mmc i=
de_pci_generic uhci_hcd sdhci mmc_core led_class ehci_hcd usbcore r8169 mii
kernel: [30720.827766] irq event stamp: 17186
kernel: [30720.827766] hardirqs last  enabled at (17185): [<c142da15>] _spi=
n_unlock_irqrestore+0x75/0x90
kernel: [30720.827766] hardirqs last disabled at (17186): [<c142d26b>] _spi=
n_lock_irq+0x1b/0x90
kernel: [30720.827766] softirqs last  enabled at (17058): [<f809101b>] ppp_=
channel_push+0xab/0xd0 [ppp_generic]
kernel: [30720.827766] softirqs last disabled at (17052): [<c142d5ea>] _rea=
d_lock_bh+0x1a/0x90
kernel: [30720.827766]=20
kernel: [30720.827766] Pid: 3132, comm: pppd Not tainted (2.6.31-rc4-dbg-gi=
t2 #1) F3JC               =20
kernel: [30720.827766] EIP: 0060:[<c1036990>] EFLAGS: 00000202 CPU: 1
kernel: [30720.827766] EIP is at sub_preempt_count+0x80/0xb0
kernel: [30720.827766] EAX: 00000001 EBX: cdd677f4 ECX: 00000101 EDX: c27d8=
000
kernel: [30720.827766] ESI: cdd677ac EDI: 00000001 EBP: c27d9e98 ESP: c27d9=
e94
kernel: [30720.827766]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [30720.827766] CR0: 8005003b CR2: b73a5000 CR3: 0275a000 CR4: 00000=
6d0
kernel: [30720.827766] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000=
000
kernel: [30720.827766] DR6: ffff0ff0 DR7: 00000400
kernel: [30720.827766] Call Trace:
kernel: [30720.827766]  [<c1266b7f>] delay_tsc+0x7f/0xc0
kernel: [30720.827766]  [<c1266a88>] __delay+0x18/0x30
kernel: [30720.827766]  [<c126c820>] _raw_spin_lock+0xf0/0x170
kernel: [30720.827766]  [<c142d22c>] _spin_lock_bh+0x6c/0x90
kernel: [30720.827766]  [<f8090f94>] ? ppp_channel_push+0x24/0xd0 [ppp_gene=
ric]
kernel: [30720.827766]  [<f8090f94>] ppp_channel_push+0x24/0xd0 [ppp_generi=
c]
kernel: [30720.827766]  [<f8091157>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [30720.827766]  [<c1109fba>] vfs_write+0xba/0x1b0
kernel: [30720.827766]  [<f8091080>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [30720.827766]  [<c110ac53>] sys_write+0x53/0xa0
kernel: [30720.827766]  [<c100358b>] sysenter_do_call+0x12/0x32
kernel: [30786.327758] BUG: soft lockup - CPU#1 stuck for 61s! [pppd:3132]
kernel: [30786.327760] Modules linked in: ppp_async crc_ccitt ppp_generic s=
lhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel=
 snd_hda_codec snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_devic=
e psmouse snd i2c_i801 serio_raw rng_core pcspkr soundcore snd_page_alloc a=
sus_laptop evdev usbhid hid
sg sd_mod sr_mod cdrom ata_generic pata_acpi ata_piix sdhci_pci ricoh_mmc i=
de_pci_generic uhci_hcd sdhci mmc_core led_class ehci_hcd usbcore r8169 mii
kernel: [30786.327760] irq event stamp: 17186
kernel: [30786.327760] hardirqs last  enabled at (17185): [<c142da15>] _spi=
n_unlock_irqrestore+0x75/0x90
kernel: [30786.327760] hardirqs last disabled at (17186): [<c142d26b>] _spi=
n_lock_irq+0x1b/0x90
kernel: [30786.327760] softirqs last  enabled at (17058): [<f809101b>] ppp_=
channel_push+0xab/0xd0 [ppp_generic]
kernel: [30786.327760] softirqs last disabled at (17052): [<c142d5ea>] _rea=
d_lock_bh+0x1a/0x90
kernel: [30786.327760]=20
kernel: [30786.327760] Pid: 3132, comm: pppd Not tainted (2.6.31-rc4-dbg-gi=
t2 #1) F3JC               =20
kernel: [30786.327760] EIP: 0060:[<c1266b2b>] EFLAGS: 00000282 CPU: 1
kernel: [30786.327760] EIP is at delay_tsc+0x2b/0xc0
kernel: [30786.327760] EAX: 00000001 EBX: c24d46f0 ECX: 00000001 EDX: 00000=
000
kernel: [30786.327760] ESI: 324bdcc1 EDI: 00000001 EBP: c27d9eb4 ESP: c27d9=
ea0
kernel: [30786.327760]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
kernel: [30786.327760] CR0: 8005003b CR2: b73a5000 CR3: 0275a000 CR4: 00000=
6d0
kernel: [30786.327760] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000=
000
kernel: [30786.327760] DR6: ffff0ff0 DR7: 00000400
kernel: [30786.327760] Call Trace:
kernel: [30786.327760]  [<c1266a88>] __delay+0x18/0x30
kernel: [30786.327760]  [<c126c820>] _raw_spin_lock+0xf0/0x170
kernel: [30786.327760]  [<c142d22c>] _spin_lock_bh+0x6c/0x90
kernel: [30786.327760]  [<f8090f94>] ? ppp_channel_push+0x24/0xd0 [ppp_gene=
ric]
kernel: [30786.327760]  [<f8090f94>] ppp_channel_push+0x24/0xd0 [ppp_generi=
c]
kernel: [30786.327760]  [<f8091157>] ppp_write+0xd7/0xe0 [ppp_generic]
kernel: [30786.327760]  [<c1109fba>] vfs_write+0xba/0x1b0
kernel: [30786.327760]  [<f8091080>] ? ppp_write+0x0/0xe0 [ppp_generic]
kernel: [30786.327760]  [<c110ac53>] sys_write+0x53/0xa0
kernel: [30786.327760]  [<c100358b>] sysenter_do_call+0x12/0x32

	Sergey

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpwCCoACgkQfKHnntdSXjR4yAP/ZCfogLICJEswoHKYxjgynR3l
6Dj1qqYOXO/aZOTv7ZpI3RiZJCtRIYQZMujsqnPF3VkzKCP99q9+NU6LbxXmdl/6
UMe+4c33oce17DjyRhF0xdfhM+zKTx9HKmMzRhJbNBcOn4EYUHAv28fyxdRhADyX
VXEmLf2NbK+NKqkpbrw=
=SheH
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
