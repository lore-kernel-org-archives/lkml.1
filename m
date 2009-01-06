Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZAFRbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZAFRbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZAFRbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:31:34 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:43997 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZAFRbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:31:33 -0500
Date: Tue, 6 Jan 2009 18:31:28 +0100
From: Nico -telmich- Schottelius <nico-linux-20090106@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico -telmich- Schottelius <nico-linux-20090106@schottelius.org>
Subject: BUG when doing rmmod kafs, 2.6.28-rc9-wl-24896-gf4f5c96
Message-ID: <20090106173128.GD27916@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-20090106@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dzs2zDY0zgkG72+7"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc9-wl-denkbrett-24896-gf4f5c96 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dzs2zDY0zgkG72+7
Content-Type: multipart/mixed; boundary="UoPmpPX/dBe4BELn"
Content-Disposition: inline


--UoPmpPX/dBe4BELn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

I wanted to play around with AFS and when trying to rmmod kafs
(to load openafs's libafs...), I get the attached bug.
I assume this is the same case for newer versions, just building
next-20090106 now.

Sincerly,

Nico

ps: as always, cc on reply me.

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--UoPmpPX/dBe4BELn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rmmod-kafs.ko-2.6.28-rc9-wl-denkbrett-24896-gf4f5c96"
Content-Transfer-Encoding: quoted-printable

[181243.008127] ------------[ cut here ]------------
[181243.008135] Kernel BUG at ffffffff802ce3c9 [verbose debug info unavaila=
ble]
[181243.008141] invalid opcode: 0000 [#1] PREEMPT SMP=20
[181243.008148] last sysfs file: /sys/class/power_supply/BAT0/energy_full
[181243.008153] CPU 0=20
[181243.008156] Modules linked in: kafs(-) af_rxrpc iwlagn usblp raid456 as=
ync_xor async_memcpy async_tx xor nfs lockd nfs_acl sunrpc tun ppp_deflate =
zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt ppp_generic slhc sie=
rra usbserial i915 drm sg sr_mod cdrom rfcomm l2cap usb_storage libusual ui=
nput autofs4 ipv6 cpufreq_powersave fuse sha256_generic aes_x86_64 aes_gene=
ric cbc dm_crypt dm_mod md_mod loop btusb bluetooth arc4 ecb snd_hda_intel =
snd_pcm snd_page_alloc snd_hwdep snd_seq iwlcore snd_timer snd_seq_device r=
tc_cmos snd ehci_hcd uhci_hcd rtc_core rtc_lib i2c_i801 e1000e mac80211 pcs=
pkr i2c_core usbcore soundcore 8250_pci 8250 serial_core ata_generic cfg802=
11 pata_acpi video output wmi thinkpad_acpi intel_agp rfkill hwmon backligh=
t led_class nvram [last unloaded: iwlagn]
[181243.008285] Pid: 20113, comm: rmmod Tainted: P           2.6.28-rc9-wl-=
denkbrett-24896-gf4f5c96 #2
[181243.008291] RIP: 0010:[<ffffffff802ce3c9>]  [<ffffffff802ce3c9>] sysfs_=
remove_one+0x6/0x64
[181243.008307] RSP: 0018:ffff880029d4de20  EFLAGS: 00010202
[181243.008312] RAX: 0000000000000001 RBX: ffff88003f42d4a8 RCX: ffff88007c=
119370
[181243.008317] RDX: 0000000000000000 RSI: ffff8800798ecbe0 RDI: ffff880029=
d4de28
[181243.008322] RBP: ffff8800798ecbe0 R08: 0000000000000001 R09: 0000000000=
000000
[181243.008327] R10: ffff88007c030ac8 R11: 00000000000003c0 R12: ffff880079=
8ecbe0
[181243.008332] R13: ffff88003f42d438 R14: 0000000000000202 R15: 0000000000=
000000
[181243.008338] FS:  00007f5eab8386e0(0000) GS:ffffffff80607240(0000) knlGS=
:0000000000000000
[181243.008344] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[181243.008349] CR2: 00007fff54738068 CR3: 0000000013680000 CR4: 0000000000=
0006e0
[181243.008354] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[181243.008359] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000=
000400
[181243.008365] Process rmmod (pid: 20113, threadinfo ffff880029d4c000, tas=
k ffff8800036918c0)
[181243.008369] Stack:
[181243.008372]  ffffffff802cec17 ffff88007c119370 ffff88003def6cf0 0000000=
000000000
[181243.008381]  0000000000000000 ffff88003f42d438 ffff88003f42d4a8 ffff880=
0798ecc08
[181243.008389]  ffffffff802cec9b ffff8800798ecbe0 0000000000000000 0000000=
000000000
[181243.008399] Call Trace:
[181243.008403]  [<ffffffff802cec17>] ? remove_dir+0x21/0x31
[181243.008412]  [<ffffffff802cec9b>] ? sysfs_remove_dir+0x72/0x7b
[181243.008420]  [<ffffffff8032e018>] ? kobject_del+0xe/0x2d
[181243.008429]  [<ffffffff80287cf6>] ? kmem_cache_destroy+0x14c/0x172
[181243.008441]  [<ffffffffa0456be5>] ? afs_exit+0x17/0x45 [kafs]
[181243.008469]  [<ffffffff80255e68>] ? sys_delete_module+0x1e2/0x245
[181243.008478]  [<ffffffff80273dad>] ? do_munmap+0x2d1/0x2f3
[181243.008487]  [<ffffffff80330e5c>] ? __up_write+0x21/0x10f
[181243.008499]  [<ffffffff8020b3fb>] ? system_call_fastpath+0x16/0x1b
[181243.008509] Code: c6 90 d5 6c 80 48 c7 c7 62 f7 54 80 31 c0 e9 db 79 1c=
 00 90 90 90 48 8b 46 38 48 39 47 40 0f 94 c0 0f b6 c0 c3 f6 46 31 02 74 04=
 <0f> 0b eb fe 48 8b 46 08 48 8d 50 28 48 8b 40 28 eb 1e 48 39 f0=20
[181243.008577] RIP  [<ffffffff802ce3c9>] sysfs_remove_one+0x6/0x64
[181243.008586]  RSP <ffff880029d4de20>
[181243.008591] ---[ end trace b83b8965b0d600b1 ]---


--UoPmpPX/dBe4BELn--

--Dzs2zDY0zgkG72+7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkljlXAACgkQuL75KpiFGIy/FgCdFqf2TnbMLbkZrZI2fME/R19+
ee0AoMtJMMCtG30yFQROnAGnav0fHxPS
=k2/9
-----END PGP SIGNATURE-----

--Dzs2zDY0zgkG72+7--
