Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYDTKf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYDTKf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYDTKfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:35:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:56629 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750768AbYDTKft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:35:49 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/G39F7foTGK1YNsUWVAt+NStddETaRHoUCYVwxuL
	ZG9H25cNNYs9Lu
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: ./fs/partitions/check.c: off-by-one error ?
Date: Sun, 20 Apr 2008 12:35:44 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1459981.E4jykAR1gJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804201235.46552.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1459981.E4jykAR1gJ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Inserting an 2 GB SD Card into my digikam and mounting it as an USB drive I=
've
in my system log :

Apr 20 12:27:54 n22 usb 2-2: new full speed USB device using uhci_hcd and a=
ddress 4
Apr 20 12:27:54 n22 usb 2-2: configuration #1 chosen from 1 choice
Apr 20 12:27:54 n22 SCSI subsystem initialized
Apr 20 12:27:54 n22 Initializing USB Mass Storage driver...
Apr 20 12:27:54 n22 scsi0 : SCSI emulation for USB Mass Storage devices
Apr 20 12:27:54 n22 usbcore: registered new interface driver usb-storage
Apr 20 12:27:54 n22 USB Mass Storage support registered.
Apr 20 12:27:54 n22 usb-storage: device found at 4
Apr 20 12:27:54 n22 usb-storage: waiting for device to settle before scanni=
ng
Apr 20 12:27:59 n22 scsi 0:0:0:0: Direct-Access     MATSHITA DMC-TZ3       =
   0100 PQ: 0 ANSI: 2
Apr 20 12:27:59 n22 usb-storage: device scan complete
Apr 20 12:27:59 n22 Driver 'sd' needs updating - please use bus_type methods
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] 3902463 512-byte hardware sectors (19=
98 MB)
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Write Protect is off
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Mode Sense: 04 00 00 00
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Assuming drive cache: write through
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] 3902463 512-byte hardware sectors (19=
98 MB)
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Write Protect is off
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Mode Sense: 04 00 00 00
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Assuming drive cache: write through
Apr 20 12:27:59 n22 sda: sda1
Apr 20 12:27:59 n22 sda: p1 exceeds device capacity
Apr 20 12:27:59 n22 sd 0:0:0:0: [sda] Attached SCSI removable disk
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334
Apr 20 12:27:59 n22 attempt to access beyond end of device
Apr 20 12:27:59 n22 sda: rw=3D0, want=3D3902464, limit=3D3902463
Apr 20 12:27:59 n22 Buffer I/O error on device sda1, logical block 3902334

My system is a :

tfoerste@n22 ~/devel/linux-2.6/fs/partitions $ uname -a
Linux n22 2.6.24-gentoo-r4 #4 Sun Apr 20 12:16:18 CEST 2008 i686 Intel(R)
Pentium(R) M processor 1700MHz GenuineIntel GNU/Linux

I already re-formatted the card under Linux as well as under Windows XP and=
 got
always the same behaviour.

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1459981.E4jykAR1gJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgLHIIACgkQhyrlCH22naO89QCgo3LdJJ16kQbZWT42+LdC9ceh
S4kAnjWhWD9h/c79HVPj9YXI8vPzsu9J
=0Ywr
-----END PGP SIGNATURE-----

--nextPart1459981.E4jykAR1gJ--
