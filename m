Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZECHMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZECHMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 03:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZECHLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 03:11:55 -0400
Received: from mx38.mail.ru ([94.100.176.52]:53973 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZECHLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 03:11:54 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-acpi@vger.kernel.org
Subject: Bank screen after resume on Dell XPS M1330
Date: Sun, 3 May 2009 11:11:47 +0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-server-4mnb; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3329045.cmNafCSNfp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905031111.50789.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3329045.cmNafCSNfp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I am struggling with new pet. One of the issues is that resume seems to=20
work but display is blank. I can blindly enter commands (e.g. to cleanly=20
reboot) so system is perfectly alive - just no output on LCD.

This happens on both 2.6.29 and 2.6.30-rc4 in both 32 and 64 bit=20
kernels. Also it happens using init=3D/bin/sh which at least rules out any=
=20
video driver issue.

lspci follows just in case. I am open for any patches and suggestions :)

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory=20
Controller Hub (rev 0c)                                                    =
             =20
00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI=20
Express Root Port (rev 0c)                                                 =
                 =20
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #4 (rev 02)                                                     =
            =20
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #5 (rev 02)                                                     =
            =20
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI=20
Controller #2 (rev 02)                                                     =
           =20
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio=20
Controller (rev 02)                                                        =
              =20
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express=20
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express=20
Port 2 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express=20
Port 4 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express=20
Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI=20
Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI=20
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface=20
Controller(rev 02)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)=20
IDE Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)=20
SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller=20
(rev 02)
01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400M GS=20
(rev a1)
03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller=20
(rev 05)
03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro=20
Host Adapter (rev 22)
03:01.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host=20
Adapter (rev 12)
03:01.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev=20
12)
09:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5906M Fast=20
Ethernet PCI Express (rev 02)
0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG=20
[Golan] Network Connection (rev 02)


--nextPart3329045.cmNafCSNfp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn9Q7MACgkQR6LMutpd94xLZgCfQJjDYwVqJywh1ARzFDritbyp
eTsAnRSxs80bCvnQw3bOznRv68wCWqnK
=XLEM
-----END PGP SIGNATURE-----

--nextPart3329045.cmNafCSNfp--
