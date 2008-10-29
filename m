Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYJ2SFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYJ2SFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYJ2SFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:05:46 -0400
Received: from mx71.mail.ru ([194.67.23.4]:55957 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYJ2SFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:05:46 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-scsi@vger.kernel.org
Subject: 2.6.28-rc2 - strange (redundant) sysfs paths for SCSI
Date: Wed, 29 Oct 2008 21:05:39 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4526605.sHybU53WzQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810292105.40220.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4526605.sHybU53WzQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Running with PATA driver:

/sys/devices/pci0000:00/0000:00:04.0/host0/scsi_host/host0
/sys/devices/pci0000:00/0000:00:04.0/host0/target0:0:0/0:0:0:0

well, in both cases at least one component is redundant? Also
the intermediate nodes (scsi_host and target0:0:0) do not seem
to contain any useful information at all?

I noticed this because kernel installer in Mandriva started to
complaint about host* and target* device nodes under /sys/bus/scsi/devices:

lrwxrwxrwx 1 root root 0 2008-10-29 19:58 0:0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/target0:0:0/0:0:0:0/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 1:0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host1/target1:0:0/1:0:0:0/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 host0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 host1 -> ../../../devices/pci0000:00/0000:00:04.0/host1/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 target0:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host0/target0:0:0/
lrwxrwxrwx 1 root root 0 2008-10-29 19:58 target1:0:0 -> ../../../devices/pci0000:00/0000:00:04.0/host1/target1:0:0/

It is really not quite clear what use they have.

TIA

-andrey

--nextPart4526605.sHybU53WzQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkIpfQACgkQR6LMutpd94xTNACguJK4lS/+Dtxab+UYXbrgTLYX
POgAnjFUVbw5ilSJ53+pi4ixgSD1stWH
=fuif
-----END PGP SIGNATURE-----

--nextPart4526605.sHybU53WzQ--
