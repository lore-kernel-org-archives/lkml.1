Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbXFJOAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbXFJOAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 10:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbXFJOA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 10:00:29 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59883 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754313AbXFJOA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 10:00:28 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: cat /dev/snapshot == OOPs
Date: Sun, 10 Jun 2007 17:00:08 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200706101542.33951.arekm@maven.pl>
In-Reply-To: <200706101542.33951.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1217301.kF9px4q407";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706101700.08985.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1217301.kF9px4q407
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

10 Haz 2007 Paz tarihinde, Arkadiusz Miskiewicz =C5=9Funlar=C4=B1 yazm=C4=
=B1=C5=9Ft=C4=B1:=20
> sudo cat /dev/snapshot

Same here with Linus's latest (although mine is tainted)

[11028.693171] swsusp: Basic memory bitmaps created
[11028.693219] BUG: unable to handle kernel NULL pointer dereference at=20
virtual address 0000000c
[11028.693227]  printing eip:
[11028.693230] c0148b33
[11028.693232] *pde =3D 00000000
[11028.693237] Oops: 0000 [#1]
[11028.693240] SMP
[11028.693244] Modules linked in: isofs zlib_inflate af_packet snd_pcm_oss=
=20
snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq=20
snd_seq_device snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc=
=20
nvidia(P) uvcvideo compat_ioctl32 videodev v4l1_compat v4l2_common hci_usb=
=20
bluetooth intel_agp agpgart tsdev usbhid hid ff_memless sdhci mmc_core=20
i2c_i801 i2c_core joydev iTCO_wdt iTCO_vendor_support firewire_ohci=20
firewire_core crc_itu_t e100 mii ipw3945 ieee80211 ieee80211_crypt=20
firmware_class serio_raw cpufreq_ondemand cpufreq_userspace cpufreq_powersa=
ve=20
acpi_cpufreq freq_table rtc_cmos rtc_core rtc_lib ext3 jbd mbcache sr_mod=20
cdrom sd_mod ata_generic ehci_hcd ata_piix ohci1394 ieee1394 uhci_hcd usbco=
re=20
ahci libata scsi_mod
[11028.693331] CPU:    0
[11028.693332] EIP:    0060:[<c0148b33>]    Tainted: P       VLI
[11028.693335] EFLAGS: 00010206   (2.6.22-rc4-CFS-v16 #4)
[11028.693344] EIP is at memory_bm_position_reset+0x5/0x1a
[11028.693349] eax: c03d808c   ebx: c03d80e0   ecx: 00000002   edx: 00000000
[11028.693355] esi: c57f6d80   edi: 08051000   ebp: 00001000   esp: e0383f50
[11028.693359] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[11028.693365] Process cat (pid: 13165, ti=3De0382000 task=3Df6109800=20
task.ti=3De0382000)
[11028.693368] Stack: c0149882 08051000 c03d80e0 c57f6d80 08051000 00000000=
=20
c014ae82 00001000
[11028.693381]        c57f6d80 c02b4d00 c0174664 e0383fa0 f6109800 08051000=
=20
c57f6d80 fffffff7
[11028.693393]        08051000 e0382000 c01749a8 e0383fa0 00000000 00000000=
=20
00000000 00000003
[11028.693404] Call Trace:
[11028.693408]  [<c0149882>] snapshot_read_next+0x6b/0x164
[11028.693425]  [<c014ae82>] snapshot_read+0x11/0x45
[11028.693438]  [<c0174664>] vfs_read+0xb1/0x15b
[11028.693456]  [<c01749a8>] sys_read+0x41/0x67
[11028.693471]  [<c0103dd0>] syscall_call+0x7/0xb
[11028.693505]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[11028.693507] Code: 74 07 89 f8 e8 5d 04 00 00 31 d2 89 f8 e8 13 2d 01 00 =
89=20
f2 eb b4 31 c0 b9 04 00 00 00 89 df f3 ab 5b 5e 5f 5d c3 8b 10 89 50 08 <8b=
>=20
52 0c c7 40 10 00 00 00 00 c7 40 14 ff ff ff ff 89 50 0c c3
[11028.693561] EIP: [<c0148b33>] memory_bm_position_reset+0x5/0x1a SS:ESP=20
0068:e0383f50
[11028.707698] swsusp: Basic memory bitmaps freed

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1217301.kF9px4q407
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGbAPoy7E6i0LKo6YRAuNfAKCxf2th7LaJ/d68bOUB7mKah+dkLgCg1D0b
l6XRNnDBlOMvZ+CcRyTKGSc=
=q8ES
-----END PGP SIGNATURE-----

--nextPart1217301.kF9px4q407--
