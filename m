Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbZGGQ0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbZGGQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZGGQ0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:26:02 -0400
Received: from mail.open.by ([193.232.92.17]:49433 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbZGGQ0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:26:00 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8963 [Jul 06 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Tue, 7 Jul 2009 19:27:54 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Message-ID: <20090707162754.GA3304@localdomain.by>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
 <dWkuWjWDsSB.A.xuF.70oUKB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <dWkuWjWDsSB.A.xuF.70oUKB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/07/09 02:00), Rafael J. Wysocki wrote:
>=20
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13522
> Subject		: BUG: scheduling while atomic
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> Date		: 2009-06-12 19:29 (25 days old)
> References	: http://lkml.org/lkml/2009/6/29/237
>=20

Hello Rafael,
it should be listed.

kernel: [ 1048.295158] BUG: scheduling while atomic: ksoftirqd/0/4/0x000005=
06
kernel: [ 1048.295169] INFO: lockdep is turned off.
kernel: [ 1048.295176] Modules linked in: ppp_deflate zlib_deflate ppp_asyn=
c crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_co=
dec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq s=
nd_timer snd_seq_device snd psmouse i2c_i801 pcspkr serio_raw rng_core soun=
dcore snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi u=
hci_hcd ricoh_mmc sdhci_pci sdhci ata_piix ide_pci_generic mmc_core led_cla=
ss ehci_hcd usbcore r8169 mii
kernel: [ 1048.295334] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc2-pnv=
-git1-00254-ga4e2f0a-dirty #2
kernel: [ 1048.295342] Call Trace:
kernel: [ 1048.295361]  [<c1035f55>] __schedule_bug+0x95/0xa0
kernel: [ 1048.295375]  [<c14394f2>] schedule+0x962/0xb60
kernel: [ 1048.295388]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.295403]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.295416]  [<c143a3df>] __mutex_lock_common+0x17f/0x450
kernel: [ 1048.295428]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.295438]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.295451]  [<c143a754>] mutex_lock_nested+0x24/0x40
kernel: [ 1048.295461]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.295472]  [<c1300355>] tty_throttle+0x25/0x70
kernel: [ 1048.295483]  [<c12fecd7>] n_tty_receive_buf+0x3a7/0x11c0
kernel: [ 1048.295495]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.295507]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.295519]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.295531]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.295550]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.295561]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.295573]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1048.295585]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1048.295596]  [<c13012d2>] ? tty_ldisc_try+0x42/0x60
kernel: [ 1048.295608]  [<c13038dd>] pty_write+0x7d/0x90
kernel: [ 1048.295624]  [<f80b3c8a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [ 1048.295639]  [<f80b3dc8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [ 1048.295655]  [<f8097086>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [ 1048.295670]  [<f8097816>] ? ppp_xmit_process+0x26/0x570 [ppp_gen=
eric]
kernel: [ 1048.295685]  [<f8097816>] ? ppp_xmit_process+0x26/0x570 [ppp_gen=
eric]
kernel: [ 1048.295702]  [<f809784a>] ppp_xmit_process+0x5a/0x570 [ppp_gener=
ic]
kernel: [ 1048.295717]  [<f8097fa5>] ? ppp_channel_push+0x95/0xd0 [ppp_gene=
ric]
kernel: [ 1048.295733]  [<f8097fb4>] ppp_channel_push+0xa4/0xd0 [ppp_generi=
c]
kernel: [ 1048.295748]  [<f8097ffe>] ppp_output_wakeup+0x1e/0x40 [ppp_gener=
ic]
kernel: [ 1048.295760]  [<f80b43f0>] ppp_async_process+0x90/0xa0 [ppp_async]
kernel: [ 1048.295773]  [<c104ee15>] tasklet_action+0xf5/0x110
kernel: [ 1048.295784]  [<c104f9ea>] __do_softirq+0xba/0x240
kernel: [ 1048.295795]  [<c104fbe5>] do_softirq+0x75/0x90
kernel: [ 1048.295807]  [<c10502e2>] ksoftirqd+0x82/0x1a0
kernel: [ 1048.295817]  [<c1050260>] ? ksoftirqd+0x0/0x1a0
kernel: [ 1048.295831]  [<c10646e4>] kthread+0x84/0x90
kernel: [ 1048.295843]  [<c1064660>] ? kthread+0x0/0x90
kernel: [ 1048.295855]  [<c1004217>] kernel_thread_helper+0x7/0x70
kernel: [ 1048.296425] BUG: scheduling while atomic: ksoftirqd/0/4/0x000004=
06
kernel: [ 1048.296431] INFO: lockdep is turned off.
kernel: [ 1048.296437] Modules linked in: ppp_deflate zlib_deflate ppp_asyn=
c crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_co=
dec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq s=
nd_timer snd_seq_device snd psmouse i2c_i801 pcspkr serio_raw rng_core soun=
dcore snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi u=
hci_hcd ricoh_mmc sdhci_pci sdhci ata_piix ide_pci_generic mmc_core led_cla=
ss ehci_hcd usbcore r8169 mii
kernel: [ 1048.296648] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc2-pnv=
-git1-00254-ga4e2f0a-dirty #2
kernel: [ 1048.296661] Call Trace:
kernel: [ 1048.296685]  [<c1035f55>] __schedule_bug+0x95/0xa0
kernel: [ 1048.296706]  [<c14394f2>] schedule+0x962/0xb60
kernel: [ 1048.296723]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.296741]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.296759]  [<c143a3df>] __mutex_lock_common+0x17f/0x450
kernel: [ 1048.296779]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.296794]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.296811]  [<c143a754>] mutex_lock_nested+0x24/0x40
kernel: [ 1048.296828]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.296842]  [<c1300355>] tty_throttle+0x25/0x70
kernel: [ 1048.296858]  [<c12fecd7>] n_tty_receive_buf+0x3a7/0x11c0
kernel: [ 1048.296872]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1048.296885]  [<c1033273>] ? __wake_up+0x53/0x70
kernel: [ 1048.296899]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.296916]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.296937]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.296955]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.296973]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.296989]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.297007]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1048.297023]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1048.297041]  [<c13012d2>] ? tty_ldisc_try+0x42/0x60
kernel: [ 1048.297057]  [<c13038dd>] pty_write+0x7d/0x90
kernel: [ 1048.297074]  [<f80b3c8a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [ 1048.297096]  [<f80b3dc8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [ 1048.297113]  [<f8097086>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [ 1048.297135]  [<c1397436>] ? skb_dequeue+0x26/0x80
kernel: [ 1048.297150]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1048.297168]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1048.297185]  [<c1397463>] ? skb_dequeue+0x53/0x80
kernel: [ 1048.297204]  [<f8097bcd>] ppp_xmit_process+0x3dd/0x570 [ppp_gene=
ric]
kernel: [ 1048.297224]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1048.297238]  [<c1397311>] ? skb_queue_tail+0x41/0x60
kernel: [ 1048.297259]  [<f8097ec7>] ppp_start_xmit+0x167/0x1b0 [ppp_generi=
c]
kernel: [ 1048.297274]  [<c13b8522>] ? __qdisc_run+0x192/0x260
kernel: [ 1048.297290]  [<c13a466c>] dev_hard_start_xmit+0x21c/0x3c0
kernel: [ 1048.297305]  [<c143bdae>] ? _spin_lock+0x6e/0x90
kernel: [ 1048.297321]  [<c13b853c>] __qdisc_run+0x1ac/0x260
kernel: [ 1048.297342]  [<c13a38e7>] net_tx_action+0xf7/0x170
kernel: [ 1048.297356]  [<c104f9ea>] __do_softirq+0xba/0x240
kernel: [ 1048.297375]  [<c104fbe5>] do_softirq+0x75/0x90
kernel: [ 1048.297389]  [<c10502e2>] ksoftirqd+0x82/0x1a0
kernel: [ 1048.297401]  [<c1050260>] ? ksoftirqd+0x0/0x1a0
kernel: [ 1048.297413]  [<c10646e4>] kthread+0x84/0x90
kernel: [ 1048.297433]  [<c1064660>] ? kthread+0x0/0x90
kernel: [ 1048.297453]  [<c1004217>] kernel_thread_helper+0x7/0x70
kernel: [ 1048.298100] BUG: scheduling while atomic: ksoftirqd/0/4/0x000004=
06
kernel: [ 1048.298115] INFO: lockdep is turned off.
kernel: [ 1048.298127] Modules linked in: ppp_deflate zlib_deflate ppp_asyn=
c crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_co=
dec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq s=
nd_timer snd_seq_device snd psmouse i2c_i801 pcspkr serio_raw rng_core soun=
dcore snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi u=
hci_hcd ricoh_mmc sdhci_pci sdhci ata_piix ide_pci_generic mmc_core led_cla=
ss ehci_hcd usbcore r8169 mii
kernel: [ 1048.298482] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc2-pnv=
-git1-00254-ga4e2f0a-dirty #2
kernel: [ 1048.298490] Call Trace:
kernel: [ 1048.298507]  [<c1035f55>] __schedule_bug+0x95/0xa0
kernel: [ 1048.298527]  [<c14394f2>] schedule+0x962/0xb60
kernel: [ 1048.298544]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.298562]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.298580]  [<c143a3df>] __mutex_lock_common+0x17f/0x450
kernel: [ 1048.298594]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.298608]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.298626]  [<c143a754>] mutex_lock_nested+0x24/0x40
kernel: [ 1048.298641]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1048.298662]  [<c1300355>] tty_throttle+0x25/0x70
kernel: [ 1048.298683]  [<c12fecd7>] n_tty_receive_buf+0x3a7/0x11c0
kernel: [ 1048.298698]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1048.298716]  [<c1033273>] ? __wake_up+0x53/0x70
kernel: [ 1048.298732]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.298750]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.298764]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1048.298780]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.298799]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.298817]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1048.298834]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1048.298849]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1048.298866]  [<c13012d2>] ? tty_ldisc_try+0x42/0x60
kernel: [ 1048.298882]  [<c13038dd>] pty_write+0x7d/0x90
kernel: [ 1048.298897]  [<f80b3c8a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [ 1048.298916]  [<f80b3dc8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [ 1048.298944]  [<f8097086>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [ 1048.298963]  [<c1397436>] ? skb_dequeue+0x26/0x80
kernel: [ 1048.298980]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1048.299000]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1048.299013]  [<c1397463>] ? skb_dequeue+0x53/0x80
kernel: [ 1048.299038]  [<f8097bcd>] ppp_xmit_process+0x3dd/0x570 [ppp_gene=
ric]
kernel: [ 1048.299054]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1048.299074]  [<c1397311>] ? skb_queue_tail+0x41/0x60
kernel: [ 1048.299092]  [<f8097ec7>] ppp_start_xmit+0x167/0x1b0 [ppp_generi=
c]
kernel: [ 1048.299110]  [<c13b8522>] ? __qdisc_run+0x192/0x260
kernel: [ 1048.299130]  [<c13a466c>] dev_hard_start_xmit+0x21c/0x3c0
kernel: [ 1048.299145]  [<c143bdae>] ? _spin_lock+0x6e/0x90
kernel: [ 1048.299168]  [<c13b853c>] __qdisc_run+0x1ac/0x260
kernel: [ 1048.299186]  [<c13a38e7>] net_tx_action+0xf7/0x170
kernel: [ 1048.299208]  [<c104f9ea>] __do_softirq+0xba/0x240
kernel: [ 1048.299226]  [<c104fbe5>] do_softirq+0x75/0x90
kernel: [ 1048.299240]  [<c10502e2>] ksoftirqd+0x82/0x1a0
kernel: [ 1048.299253]  [<c1050260>] ? ksoftirqd+0x0/0x1a0
kernel: [ 1048.299268]  [<c10646e4>] kthread+0x84/0x90
kernel: [ 1048.299288]  [<c1064660>] ? kthread+0x0/0x90
kernel: [ 1048.299301]  [<c1004217>] kernel_thread_helper+0x7/0x70
kernel: [ 1067.299845] BUG: scheduling while atomic: ksoftirqd/0/4/0x000005=
06
kernel: [ 1067.299854] INFO: lockdep is turned off.
kernel: [ 1067.299860] Modules linked in: ppp_deflate zlib_deflate ppp_asyn=
c crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_co=
dec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq s=
nd_timer snd_seq_device snd psmouse i2c_i801 pcspkr serio_raw rng_core soun=
dcore snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi u=
hci_hcd ricoh_mmc sdhci_pci sdhci ata_piix ide_pci_generic mmc_core led_cla=
ss ehci_hcd usbcore r8169 mii
kernel: [ 1067.300216] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc2-pnv=
-git1-00254-ga4e2f0a-dirty #2
kernel: [ 1067.300229] Call Trace:
kernel: [ 1067.300249]  [<c1035f55>] __schedule_bug+0x95/0xa0
kernel: [ 1067.300270]  [<c14394f2>] schedule+0x962/0xb60
kernel: [ 1067.300289]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1067.300306]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1067.300324]  [<c143a3df>] __mutex_lock_common+0x17f/0x450
kernel: [ 1067.300347]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1067.300365]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1067.300384]  [<c143a754>] mutex_lock_nested+0x24/0x40
kernel: [ 1067.300400]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1067.300418]  [<c1300355>] tty_throttle+0x25/0x70
kernel: [ 1067.300438]  [<c12fecd7>] n_tty_receive_buf+0x3a7/0x11c0
kernel: [ 1067.300452]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1067.300468]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1067.300485]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1067.300502]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1067.300518]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1067.300535]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1067.300554]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1067.300569]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1067.300585]  [<c13012d2>] ? tty_ldisc_try+0x42/0x60
kernel: [ 1067.300600]  [<c13038dd>] pty_write+0x7d/0x90
kernel: [ 1067.300621]  [<f80b3c8a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [ 1067.300640]  [<f80b3dc8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [ 1067.300665]  [<f8097086>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [ 1067.300687]  [<f8097816>] ? ppp_xmit_process+0x26/0x570 [ppp_gen=
eric]
kernel: [ 1067.300709]  [<f8097816>] ? ppp_xmit_process+0x26/0x570 [ppp_gen=
eric]
kernel: [ 1067.300731]  [<f809784a>] ppp_xmit_process+0x5a/0x570 [ppp_gener=
ic]
kernel: [ 1067.300746]  [<f8097fa5>] ? ppp_channel_push+0x95/0xd0 [ppp_gene=
ric]
kernel: [ 1067.300763]  [<f8097fb4>] ppp_channel_push+0xa4/0xd0 [ppp_generi=
c]
kernel: [ 1067.300781]  [<f8097ffe>] ppp_output_wakeup+0x1e/0x40 [ppp_gener=
ic]
kernel: [ 1067.300804]  [<f80b43f0>] ppp_async_process+0x90/0xa0 [ppp_async]
kernel: [ 1067.300822]  [<c104ee15>] tasklet_action+0xf5/0x110
kernel: [ 1067.300841]  [<c104f9ea>] __do_softirq+0xba/0x240
kernel: [ 1067.300855]  [<c104fbe5>] do_softirq+0x75/0x90
kernel: [ 1067.300873]  [<c10502e2>] ksoftirqd+0x82/0x1a0
kernel: [ 1067.300886]  [<c1050260>] ? ksoftirqd+0x0/0x1a0
kernel: [ 1067.300901]  [<c10646e4>] kthread+0x84/0x90
kernel: [ 1067.300918]  [<c1064660>] ? kthread+0x0/0x90
kernel: [ 1067.300937]  [<c1004217>] kernel_thread_helper+0x7/0x70
kernel: [ 1067.301595] BUG: scheduling while atomic: ksoftirqd/0/4/0x000004=
06
kernel: [ 1067.301608] INFO: lockdep is turned off.
kernel: [ 1067.301617] Modules linked in: ppp_deflate zlib_deflate ppp_asyn=
c crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_co=
dec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq s=
nd_timer snd_seq_device snd psmouse i2c_i801 pcspkr serio_raw rng_core soun=
dcore snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi u=
hci_hcd ricoh_mmc sdhci_pci sdhci ata_piix ide_pci_generic mmc_core led_cla=
ss ehci_hcd usbcore r8169 mii
kernel: [ 1067.301969] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc2-pnv=
-git1-00254-ga4e2f0a-dirty #2
kernel: [ 1067.301981] Call Trace:
kernel: [ 1067.301998]  [<c1035f55>] __schedule_bug+0x95/0xa0
kernel: [ 1067.302018]  [<c14394f2>] schedule+0x962/0xb60
kernel: [ 1067.302031]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1067.302052]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1067.302072]  [<c143a3df>] __mutex_lock_common+0x17f/0x450
kernel: [ 1067.302092]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1067.302110]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1067.302126]  [<c143a754>] mutex_lock_nested+0x24/0x40
kernel: [ 1067.302139]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1067.302152]  [<c1300355>] tty_throttle+0x25/0x70
kernel: [ 1067.302167]  [<c12fecd7>] n_tty_receive_buf+0x3a7/0x11c0
kernel: [ 1067.302188]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1067.302203]  [<c1033273>] ? __wake_up+0x53/0x70
kernel: [ 1067.302219]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1067.302234]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1067.302251]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1067.302268]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1067.302284]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1067.302301]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1067.302319]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1067.302339]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1067.302352]  [<c13012d2>] ? tty_ldisc_try+0x42/0x60
kernel: [ 1067.302370]  [<c13038dd>] pty_write+0x7d/0x90
kernel: [ 1067.302389]  [<f80b3c8a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [ 1067.302412]  [<f80b3dc8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [ 1067.302437]  [<f8097086>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [ 1067.302454]  [<c1397436>] ? skb_dequeue+0x26/0x80
kernel: [ 1067.302473]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1067.302490]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1067.302503]  [<c1397463>] ? skb_dequeue+0x53/0x80
kernel: [ 1067.302526]  [<f8097bcd>] ppp_xmit_process+0x3dd/0x570 [ppp_gene=
ric]
kernel: [ 1067.302541]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1067.302558]  [<c1397311>] ? skb_queue_tail+0x41/0x60
kernel: [ 1067.302577]  [<f8097ec7>] ppp_start_xmit+0x167/0x1b0 [ppp_generi=
c]
kernel: [ 1067.302601]  [<c13b8522>] ? __qdisc_run+0x192/0x260
kernel: [ 1067.302622]  [<c13a466c>] dev_hard_start_xmit+0x21c/0x3c0
kernel: [ 1067.302640]  [<c143bdae>] ? _spin_lock+0x6e/0x90
kernel: [ 1067.302654]  [<c13b853c>] __qdisc_run+0x1ac/0x260
kernel: [ 1067.302675]  [<c13a38e7>] net_tx_action+0xf7/0x170
kernel: [ 1067.302698]  [<c104f9ea>] __do_softirq+0xba/0x240
kernel: [ 1067.302713]  [<c104fbe5>] do_softirq+0x75/0x90
kernel: [ 1067.302728]  [<c10502e2>] ksoftirqd+0x82/0x1a0
kernel: [ 1067.302745]  [<c1050260>] ? ksoftirqd+0x0/0x1a0
kernel: [ 1067.302761]  [<c10646e4>] kthread+0x84/0x90
kernel: [ 1067.302783]  [<c1064660>] ? kthread+0x0/0x90
kernel: [ 1067.302798]  [<c1004217>] kernel_thread_helper+0x7/0x70
kernel: [ 1076.490281] BUG: scheduling while atomic: ksoftirqd/0/4/0x000004=
06
kernel: [ 1076.490290] INFO: lockdep is turned off.
kernel: [ 1076.490296] Modules linked in: ppp_deflate zlib_deflate ppp_asyn=
c crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_co=
dec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq s=
nd_timer snd_seq_device snd psmouse i2c_i801 pcspkr serio_raw rng_core soun=
dcore snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi u=
hci_hcd ricoh_mmc sdhci_pci sdhci ata_piix ide_pci_generic mmc_core led_cla=
ss ehci_hcd usbcore r8169 mii
kernel: [ 1076.490452] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc2-pnv=
-git1-00254-ga4e2f0a-dirty #2
kernel: [ 1076.490460] Call Trace:
kernel: [ 1076.490478]  [<c1035f55>] __schedule_bug+0x95/0xa0
kernel: [ 1076.490492]  [<c14394f2>] schedule+0x962/0xb60
kernel: [ 1076.490506]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1076.490521]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1076.490534]  [<c143a3df>] __mutex_lock_common+0x17f/0x450
kernel: [ 1076.490545]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1076.490556]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1076.490568]  [<c143a754>] mutex_lock_nested+0x24/0x40
kernel: [ 1076.490579]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1076.490590]  [<c1300355>] tty_throttle+0x25/0x70
kernel: [ 1076.490601]  [<c12fecd7>] n_tty_receive_buf+0x3a7/0x11c0
kernel: [ 1076.490613]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1076.490625]  [<c1033273>] ? __wake_up+0x53/0x70
kernel: [ 1076.490636]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1076.490648]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1076.490659]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1076.490672]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1076.490682]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1076.490693]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1076.490705]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1076.490717]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1076.490728]  [<c13012d2>] ? tty_ldisc_try+0x42/0x60
kernel: [ 1076.490741]  [<c13038dd>] pty_write+0x7d/0x90
kernel: [ 1076.490757]  [<f80b3c8a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [ 1076.490774]  [<f80b3dc8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [ 1076.490790]  [<f8097086>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [ 1076.490802]  [<c1397436>] ? skb_dequeue+0x26/0x80
kernel: [ 1076.490815]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1076.490835]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1076.490846]  [<c1397463>] ? skb_dequeue+0x53/0x80
kernel: [ 1076.490861]  [<f8097bcd>] ppp_xmit_process+0x3dd/0x570 [ppp_gene=
ric]
kernel: [ 1076.490874]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1076.490885]  [<c1397311>] ? skb_queue_tail+0x41/0x60
kernel: [ 1076.490900]  [<f8097ec7>] ppp_start_xmit+0x167/0x1b0 [ppp_generi=
c]
kernel: [ 1076.490912]  [<c13b8522>] ? __qdisc_run+0x192/0x260
kernel: [ 1076.490925]  [<c13a466c>] dev_hard_start_xmit+0x21c/0x3c0
kernel: [ 1076.490937]  [<c143bdae>] ? _spin_lock+0x6e/0x90
kernel: [ 1076.490948]  [<c13b853c>] __qdisc_run+0x1ac/0x260
kernel: [ 1076.490960]  [<c13a38e7>] net_tx_action+0xf7/0x170
kernel: [ 1076.490972]  [<c104f9ea>] __do_softirq+0xba/0x240
kernel: [ 1076.490984]  [<c104fbe5>] do_softirq+0x75/0x90
kernel: [ 1076.490995]  [<c10502e2>] ksoftirqd+0x82/0x1a0
kernel: [ 1076.491005]  [<c1050260>] ? ksoftirqd+0x0/0x1a0
kernel: [ 1076.491017]  [<c10646e4>] kthread+0x84/0x90
kernel: [ 1076.491029]  [<c1064660>] ? kthread+0x0/0x90
kernel: [ 1076.491041]  [<c1004217>] kernel_thread_helper+0x7/0x70
kernel: [ 1076.491622] BUG: scheduling while atomic: ksoftirqd/0/4/0x000004=
06
kernel: [ 1076.491629] INFO: lockdep is turned off.
kernel: [ 1076.491635] Modules linked in: ppp_deflate zlib_deflate ppp_asyn=
c crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_co=
dec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq s=
nd_timer snd_seq_device snd psmouse i2c_i801 pcspkr serio_raw rng_core soun=
dcore snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi u=
hci_hcd ricoh_mmc sdhci_pci sdhci ata_piix ide_pci_generic mmc_core led_cla=
ss ehci_hcd usbcore r8169 mii
kernel: [ 1076.491786] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc2-pnv=
-git1-00254-ga4e2f0a-dirty #2
kernel: [ 1076.491794] Call Trace:
kernel: [ 1076.491807]  [<c1035f55>] __schedule_bug+0x95/0xa0
kernel: [ 1076.491818]  [<c14394f2>] schedule+0x962/0xb60
kernel: [ 1076.491829]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1076.491842]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1076.491856]  [<c143a3df>] __mutex_lock_common+0x17f/0x450
kernel: [ 1076.491867]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1076.491877]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1076.491889]  [<c143a754>] mutex_lock_nested+0x24/0x40
kernel: [ 1076.491900]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1076.491910]  [<c1300355>] tty_throttle+0x25/0x70
kernel: [ 1076.491921]  [<c12fecd7>] n_tty_receive_buf+0x3a7/0x11c0
kernel: [ 1076.491933]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1076.491945]  [<c1033273>] ? __wake_up+0x53/0x70
kernel: [ 1076.491955]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1076.491967]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1076.491979]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1076.491991]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1076.492001]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1076.492012]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1076.492024]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1076.492035]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1076.492047]  [<c13012d2>] ? tty_ldisc_try+0x42/0x60
kernel: [ 1076.492058]  [<c13038dd>] pty_write+0x7d/0x90
kernel: [ 1076.492072]  [<f80b3c8a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [ 1076.492088]  [<f80b3dc8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [ 1076.492103]  [<f8097086>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [ 1076.492114]  [<c1397436>] ? skb_dequeue+0x26/0x80
kernel: [ 1076.492126]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1076.492138]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1076.492149]  [<c1397463>] ? skb_dequeue+0x53/0x80
kernel: [ 1076.492164]  [<f8097bcd>] ppp_xmit_process+0x3dd/0x570 [ppp_gene=
ric]
kernel: [ 1076.492176]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1076.492187]  [<c1397311>] ? skb_queue_tail+0x41/0x60
kernel: [ 1076.492202]  [<f8097ec7>] ppp_start_xmit+0x167/0x1b0 [ppp_generi=
c]
kernel: [ 1076.492213]  [<c13b8522>] ? __qdisc_run+0x192/0x260
kernel: [ 1076.492225]  [<c13a466c>] dev_hard_start_xmit+0x21c/0x3c0
kernel: [ 1076.492236]  [<c143bdae>] ? _spin_lock+0x6e/0x90
kernel: [ 1076.492248]  [<c13b853c>] __qdisc_run+0x1ac/0x260
kernel: [ 1076.492259]  [<c13a38e7>] net_tx_action+0xf7/0x170
kernel: [ 1076.492270]  [<c104f9ea>] __do_softirq+0xba/0x240
kernel: [ 1076.492282]  [<c104fbe5>] do_softirq+0x75/0x90
kernel: [ 1076.492292]  [<c10502e2>] ksoftirqd+0x82/0x1a0
kernel: [ 1076.492302]  [<c1050260>] ? ksoftirqd+0x0/0x1a0
kernel: [ 1076.492313]  [<c10646e4>] kthread+0x84/0x90
kernel: [ 1076.492325]  [<c1064660>] ? kthread+0x0/0x90
kernel: [ 1076.492336]  [<c1004217>] kernel_thread_helper+0x7/0x70
kernel: [ 1117.962740] BUG: scheduling while atomic: ksoftirqd/0/4/0x000004=
06
kernel: [ 1117.962750] INFO: lockdep is turned off.
kernel: [ 1117.962756] Modules linked in: ppp_deflate zlib_deflate ppp_asyn=
c crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_co=
dec_realtek snd_hda_intel
snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq s=
nd_timer snd_seq_device snd psmouse i2c_i801 pcspkr serio_raw rng_core soun=
dcore snd_page_alloc
asus_laptop evdev usbhid hid sg sr_mod cdrom sd_mod ata_generic pata_acpi u=
hci_hcd ricoh_mmc sdhci_pci sdhci ata_piix ide_pci_generic mmc_core led_cla=
ss ehci_hcd usbcore r8169 mii
kernel: [ 1117.962910] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc2-pnv=
-git1-00254-ga4e2f0a-dirty #2
kernel: [ 1117.962918] Call Trace:
kernel: [ 1117.962937]  [<c1035f55>] __schedule_bug+0x95/0xa0
kernel: [ 1117.962950]  [<c14394f2>] schedule+0x962/0xb60
kernel: [ 1117.962963]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1117.962978]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1117.962991]  [<c143a3df>] __mutex_lock_common+0x17f/0x450
kernel: [ 1117.963002]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1117.963013]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1117.963025]  [<c143a754>] mutex_lock_nested+0x24/0x40
kernel: [ 1117.963035]  [<c1300355>] ? tty_throttle+0x25/0x70
kernel: [ 1117.963046]  [<c1300355>] tty_throttle+0x25/0x70
kernel: [ 1117.963057]  [<c12fecd7>] n_tty_receive_buf+0x3a7/0x11c0
kernel: [ 1117.963069]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1117.963081]  [<c1033273>] ? __wake_up+0x53/0x70
kernel: [ 1117.963092]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1117.963103]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1117.963115]  [<c107b015>] ? print_lock_contention_bug+0x25/0x100
kernel: [ 1117.963127]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1117.963138]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1117.963149]  [<c13012b5>] ? tty_ldisc_try+0x25/0x60
kernel: [ 1117.963161]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1117.963172]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1117.963184]  [<c13012d2>] ? tty_ldisc_try+0x42/0x60
kernel: [ 1117.963195]  [<c13038dd>] pty_write+0x7d/0x90
kernel: [ 1117.963210]  [<f80b3c8a>] ppp_async_push+0x3da/0x4d0 [ppp_async]
kernel: [ 1117.963263]  [<f80b3dc8>] ppp_async_send+0x48/0x70 [ppp_async]
kernel: [ 1117.963285]  [<f8097086>] ppp_push+0x176/0x5f0 [ppp_generic]
kernel: [ 1117.963304]  [<c1397436>] ? skb_dequeue+0x26/0x80
kernel: [ 1117.963319]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1117.963335]  [<c143c5f7>] ? _spin_unlock_irqrestore+0x47/0x90
kernel: [ 1117.963350]  [<c1397463>] ? skb_dequeue+0x53/0x80
kernel: [ 1117.963369]  [<f8097bcd>] ppp_xmit_process+0x3dd/0x570 [ppp_gene=
ric]
kernel: [ 1117.963385]  [<c107c709>] ? trace_hardirqs_on+0x19/0x40
kernel: [ 1117.963403]  [<c1397311>] ? skb_queue_tail+0x41/0x60
kernel: [ 1117.963420]  [<f8097ec7>] ppp_start_xmit+0x167/0x1b0 [ppp_generi=
c]
kernel: [ 1117.963440]  [<c13b8522>] ? __qdisc_run+0x192/0x260
kernel: [ 1117.963459]  [<c13a466c>] dev_hard_start_xmit+0x21c/0x3c0
kernel: [ 1117.963473]  [<c143bdae>] ? _spin_lock+0x6e/0x90
kernel: [ 1117.963489]  [<c13b853c>] __qdisc_run+0x1ac/0x260
kernel: [ 1117.963502]  [<c13a38e7>] net_tx_action+0xf7/0x170
kernel: [ 1117.963521]  [<c104f9ea>] __do_softirq+0xba/0x240
kernel: [ 1117.963536]  [<c1272008>] ? trace_hardirqs_on_thunk+0xc/0x10
kernel: [ 1117.963552]  [<c104fbe5>] do_softirq+0x75/0x90
kernel: [ 1117.963569]  [<c10502e2>] ksoftirqd+0x82/0x1a0
kernel: [ 1117.963585]  [<c1050260>] ? ksoftirqd+0x0/0x1a0
kernel: [ 1117.963602]  [<c10646e4>] kthread+0x84/0x90
kernel: [ 1117.963624]  [<c1064660>] ? kthread+0x0/0x90
kernel: [ 1117.963641]  [<c1004217>] kernel_thread_helper+0x7/0x70

	Sergey
--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpTd4oACgkQfKHnntdSXjQjcgP/bji9y4SkwdXn/eUtMb0DepYU
x5PZJipyu8bMoYJgzPXngiW5jgH3K0fMY0aSU61GJ6jQWhC7Lg6pMQS6zjcBYbTJ
ZvPpYcKl0sIHHWM0Ak+MT3CksLGEleu/wRl4ILJLAaW+fGoWGcjL7xBAiSjv3n71
c1WRioMcHX9RhEWNhYo=
=UxrJ
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
