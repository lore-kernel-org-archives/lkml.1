Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYJESFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYJESFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 14:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYJESFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 14:05:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41221 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbYJESFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 14:05:39 -0400
From: Peter Alfredsen <loki_val@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: SATA Burner Pioneer DVR-216-DBK won't burn
Date: Sun, 5 Oct 2008 20:04:50 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1784702.ibx1SnnRSH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810052005.04920.loki_val@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1784702.ibx1SnnRSH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[please CC me on replies]
Linux loki 2.6.27-rc8 #5 SMP PREEMPT Sun Oct 5 17:56:00 CEST 2008 x86_64=20
Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz GenuineIntel GNU/Linux

I recently acquired a DVR-216-DBK Pioneer SATA burner. With my old=20
burner, a DVR-110D,  I am able to burn a DVD. With the DVR-216DBK, I'm=20
not, it stops always at 98%, no matter which speed I burn at.

My motherboard is a ASUS P5Q-EM, I have 8GB of ram and am running Gentoo=20
Linux. I've tried both cdrkit and cdrtools.
DVR-216-DBK Fails, connected to ICH10R AHCI SATA controller
DVR-110D Succeeds, connected to Marvell 6101 PATA_MARVELL controller

I've located other people who seem to be experiencing the same thing:

http://bugs.kde.org/show_bug.cgi?id=3D169294
http://ubuntuforums.org/showthread.php?t=3D543483

This seems to me to point to a problem with the AHCI driver's=20
interaction with the drive.

Attached is lspci -k and debug output from K3B:

00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller=20
(rev 03)
        Kernel driver in use: agpgart-intel
00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset=20
Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation 4 Series Chipset=20
Integrated Graphics Controller (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB=20
UHCI Controller #4
        Kernel driver in use: uhci_hcd
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB=20
UHCI Controller #5
        Kernel driver in use: uhci_hcd
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB=20
UHCI Controller #6
        Kernel driver in use: uhci_hcd
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2=20
EHCI Controller #2
        Kernel driver in use: ehci_hcd
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio=20
Controller
        Kernel driver in use: HDA Intel
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express=20
Port 1
        Kernel driver in use: pcieport-driver
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express=20
Port 5
        Kernel driver in use: pcieport-driver
00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express=20
Port 6
        Kernel driver in use: pcieport-driver
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB=20
UHCI Controller #1
        Kernel driver in use: uhci_hcd
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB=20
UHCI Controller #2
        Kernel driver in use: uhci_hcd
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB=20
UHCI Controller #3
        Kernel driver in use: uhci_hcd
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2=20
EHCI Controller #1
        Kernel driver in use: ehci_hcd
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface=20
Controller
00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA=20
AHCI Controller
        Kernel driver in use: ahci
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
        Kernel driver in use: i801_smbus
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.=20
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
        Kernel driver in use: r8169
02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101=20
single-port PATA133 interface (rev b2)
        Kernel driver in use: pata_marvell
        Kernel modules: pata_marvell
04:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 70)
        Kernel driver in use: firewire_ohci




System
=2D----------------------
K3b Version: 1.0.5

KDE Version: 3.5.10
QT Version:  3.3.8b
Kernel:      2.6.27-rc8
Devices
=2D----------------------
PIONEER DVD-RW  DVR-110D 1.41 (/dev/sr1, ) [CD-R, CD-RW, CD-ROM,=20
DVD-ROM, DVD-R, DVD-RW, DVD-R DL, DVD+R, DVD+RW, DVD+R DL] [DVD-ROM,=20
DVD-R Sequential, DVD-R Dual Layer Sequential, DVD-R Dual Layer Jump,=20
DVD-RW Restricted Overwrite, DVD-RW Sequential, DVD+RW, DVD+R, DVD+R=20
Dual Layer, CD-ROM, CD-R, CD-RW] [SAO, TAO, RAW, SAO/R96P, SAO/R96R,=20
RAW/R16, RAW/R96P, RAW/R96R, Restricted Overwrite, Layer Jump]

PIONEER DVD-RW  DVR-216D 1.04 (/dev/sr0, ) [CD-R, CD-RW, CD-ROM,=20
DVD-ROM, DVD-R, DVD-RW, DVD-R DL, DVD+R, DVD+RW, DVD+R DL] [DVD-ROM,=20
DVD-R Sequential, DVD-R Dual Layer Sequential, DVD-R Dual Layer Jump,=20
DVD-RW Restricted Overwrite, DVD-RW Sequential, DVD+RW, DVD+R, DVD+R=20
Dual Layer, CD-ROM, CD-R, CD-RW] [SAO, TAO, RAW, SAO/R96P, SAO/R96R,=20
RAW/R16, RAW/R96P, RAW/R96R, Restricted Overwrite, Layer Jump]
Burned media
=2D----------------------
DVD-R Sequential

K3bIsoImager
=2D----------------------
mkisofs print size result: 1957074 (4008087552 bytes)
Pipe throughput: 4008087552 bytes read, 4008087552 bytes written.

Used versions
=2D----------------------
mkisofs: 2.1.1a50
growisofs: 7.1

growisofs
=2D----------------------
Executing 'builtin_dd if=3D/dev/fd/0 of=3D/dev/sr0 obs=3D32k seek=3D0'
/dev/sr0: engaging DVD-R DAO upon user request...
/dev/sr0: reserving 1957074 blocks
/dev/sr0: "Current Write Speed" is 20.5x1352KBps.
    1572864/4008087552 ( 0.0%) @0.0x, remaining 212:16 RBU 100.0% UBU  =20
2.0%
[A lot of the same omitted]
 3942252544/4008087552 (98.4%) @16.8x, remaining 0:03 RBU 100.0% UBU=20
100.0%
:-[ WRITE@LBA=3D1ddcd0h failed with SK=3D5h/ASC=3DA8h/ACQ=3D04h]: Input/out=
put=20
error
:-( write failed: Input/output error
/dev/sr0: flushing cache

growisofs command:
=2D----------------------
/usr/bin/growisofs -Z /dev/sr0=3D/dev/fd/0 -use-the-force-luke=3Dnotray -us=
e-the-force-luke=3Dtty -use-the-force-luke=3Dtracksize:1957074 -use-the-for=
ce-luke=3Ddao:1957074 -dvd-compat -speed=3D20 -use-the-force-luke=3Dbufsize=
:32m=20

mkisofs
=2D----------------------
1957074
/usr/bin/mkisofs: Warning: Cannot add inode hints with -no-cache-inodes.
/usr/bin/mkisofs: Warning: Cannot add inode hints with -no-cache-inodes.
/usr/bin/mkisofs: Warning: Cannot add inode hints with -no-cache-inodes.
Setting input-charset to 'UTF-8' from locale.
  0.03% done, estimate finish Sun Oct  5 19:10:06 2008
[a few houndred lines omitted for brevity's sake]
 99.97% done, estimate finish Sun Oct  5 19:14:14 2008
Total translation table size: 0
Total rockridge attributes bytes: 0
Total directory bytes: 4248
Path table size(bytes): 42
Max brk space used 0
1957074 extents written (3822 MB)

mkisofs calculate size command:
=2D----------------------
/usr/bin/mkisofs -gui -graft-points -print-size -quiet -volid=20
madrid07 -volset  -appid K3B THE CD KREATOR (C) 1998-2006 SEBASTIAN=20
TRUEG AND THE K3B TEAM -publisher  -preparer  -sysid LINUX -volset-size=20
1 -volset-seqno=20
1 -sort /tmp/kde-pa/k3b26pqfa.tmp -no-cache-inodes -udf -iso-level=20
1 -path-list /tmp/kde-pa/k3bdhn4Wb.tmp -dvd-video -f /tmp/kde-pa/k3bVideoDv=
d0=20

mkisofs command:
=2D----------------------
/usr/bin/mkisofs -gui -graft-points -volid madrid07 -volset  -appid K3B=20
THE CD KREATOR (C) 1998-2006 SEBASTIAN TRUEG AND THE K3B=20
TEAM -publisher  -preparer  -sysid LINUX -volset-size 1 -volset-seqno=20
1 -sort /tmp/kde-pa/k3bKNxcVb.tmp -no-cache-inodes -udf -iso-level=20
1 -path-list /tmp/kde-pa/k3bM12aPb.tmp -dvd-video -f /tmp/kde-pa/k3bVideoDv=
d0=20



=2D-=20
/PA

--nextPart1784702.ibx1SnnRSH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjpAdAACgkQtEGUx4TfHiQ7bQCgi6rY+9vofYH/i7dg8NVWKaKs
s/gAn3yZ8GUy8me036VjR+tlJZbKRJ+c
=EU26
-----END PGP SIGNATURE-----

--nextPart1784702.ibx1SnnRSH--
