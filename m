Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYHZXYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYHZXYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYHZXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:23:41 -0400
Received: from quackingmoose.com ([63.73.180.143]:49178 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750990AbYHZXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:23:40 -0400
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 19:23:40 EDT
Date: Tue, 26 Aug 2008 16:04:12 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: linux-kernel@vger.kernel.org, raven@themaw.net
Subject: autofs graft_tree panic
Message-ID: <20080826230412.GD5452@merfinllc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I just wanted to mention we still see this panic in 2.6.26.3.

Seems to be a known problem that became less probable in 2.6.26?

Thanks!

				=3Da=3D
 =20
Aug 26 08:02:47 catfish kernel: PGD cbb7c067 PUD cbb8a067 PMD 0=20
Aug 26 08:02:47 catfish kernel: CPU 1=20
Aug 26 08:02:47 catfish kernel: Modules linked in: tun nfsd exportfs kvm au=
tofs4 acpi_cpufreq cpufreq_ondemand cpufreq_conservative cpufreq_powersave =
cpufreq_userspace cpufreq_stats freq_table container battery nfs lockd sunr=
pc bridge llc iptable_filter ip_tables x_tables ac snd_hda_intel snd_pcm_os=
s snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi =
snd_seq_midi_event snd_seq evdev psmouse rtc button snd_timer e1000e snd_se=
q_device snd soundcore snd_page_alloc usbhid sr_mod cdrom sd_mod sg ehci_hc=
d uhci_hcd usbcore thermal processor fan fuse
Aug 26 08:02:47 catfish kernel: Pid: 25973, comm: mount.nfs Not tainted 2.6=
=2E26.3-asb #24
Aug 26 08:02:47 catfish kernel: RIP: 0010:[<ffffffff8028cb1b>]  [<ffffffff8=
028cb1b>] graft_tree+0x2e/0xbc
Aug 26 08:02:47 catfish kernel: RSP: 0018:ffff8100cbc61df8  EFLAGS: 00010246
Aug 26 08:02:47 catfish kernel: RAX: ffff8100cedd2c80 RBX: 00000000ffffffec=
 RCX: 0000000000000000
Aug 26 08:02:47 catfish kernel: RDX: ffff810126b8ef00 RSI: ffff8100cbc61e58=
 RDI: ffff810126567100
Aug 26 08:02:47 catfish kernel: RBP: ffff8100cbc61e58 R08: 0000000100000002=
 R09: ffffffff80508228
Aug 26 08:02:47 catfish kernel: R10: ffff81012647b7c0 R11: ffff8100cbbb6000=
 R12: ffff810126567100
Aug 26 08:02:47 catfish kernel: R13: ffff8100cbc61e60 R14: 0000000000000000=
 R15: ffff8100cbd21000
Aug 26 08:02:47 catfish kernel: FS:  0000000000000000(0000) GS:ffff810127c0=
5480(0063) knlGS:00000000f7e0f6b0
Aug 26 08:02:47 catfish kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080=
05003b
Aug 26 08:02:47 catfish kernel: CR2: 00000000000000b2 CR3: 00000000cbb94000=
 CR4: 00000000000006e0
Aug 26 08:02:47 catfish kernel: DR0: 0000000000000000 DR1: 0000000000000000=
 DR2: 0000000000000000
Aug 26 08:02:47 catfish kernel: DR3: 0000000000000000 DR6: 00000000ffff4ff0=
 DR7: 0000000000000400
Aug 26 08:02:47 catfish kernel: Process mount.nfs (pid: 25973, threadinfo f=
fff8100cbc60000, task ffff810120ed5190)
Aug 26 08:02:47 catfish kernel: Stack:  ffff810126567100 ffff8100cbc61e58 0=
000000000000000 ffffffff8028cdbf
Aug 26 08:02:47 catfish kernel:  0000000000000000 0000000000000000 ffff8100=
cbc61e58 ffff8101270f5000
Aug 26 08:02:47 catfish kernel:  ffff8100cc739000 ffffffff8028eab6 00000000=
00000292 ffff8100cbbb6000
Aug 26 08:02:47 catfish kernel: Call Trace:
Aug 26 08:02:47 catfish kernel:  [<ffffffff8028cdbf>] ? do_add_mount+0xa5/0=
x10d
Aug 26 08:02:47 catfish kernel:  [<ffffffff8028eab6>] ? do_mount+0x189/0x1b6
Aug 26 08:02:47 catfish kernel:  [<ffffffff8028c620>] ? copy_mount_options+=
0xc7/0x12e
Aug 26 08:02:47 catfish kernel:  [<ffffffff802a4fba>] ? compat_sys_mount+0x=
1fc/0x24a
Aug 26 08:02:47 catfish kernel:  [<ffffffff80220062>] ? sysenter_do_call+0x=
1b/0x66
Aug 26 08:02:47 catfish kernel:=20
Aug 26 08:02:47 catfish kernel:=20
Aug 26 08:02:47 catfish kernel:  RSP <ffff8100cbc61df8>
Aug 26 08:02:47 catfish kernel: ---[ end trace e90fc77bb0c12e25 ]---

--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aaron Straus
aaron@merfinllc.com

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFItIvsr/o4YuvB+jgRArSJAJ0VDot4YM11xqZI36BJqNk2ezSyjwCfS06E
2nXjO/L4tn7Zw8z3J6NnuNc=
=amXQ
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
