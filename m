Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXBZGpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXBZGpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 01:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXBZGpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 01:45:04 -0500
Received: from iucha.net ([209.98.146.184]:55328 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbXBZGpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 01:45:02 -0500
Date: Mon, 26 Feb 2007 00:45:00 -0600
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.20-rc1: CIFS cheers, NFS4 jeers
Message-ID: <20070226064500.GZ29073@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="56p9wBiXEyg+KhLM"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--56p9wBiXEyg+KhLM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello, it's me and my 70 GB of photos again.

I have tested both CIFS and NFSv4 clients in kernel 2.6.20-rc1 . CIFS
passed with flying colors and NFSv4 stalled after 7 GB.

Configuration:

   Server: PIII/1GHz, 512 MB RAM, Debian testing,
      distro kernel 2.6.18-3-vserver-686, Intel E1000 NIC,=20
      filesystem 170 GB ext3 with default mkfs values on a SATA disk
     =20
   Client: AMD x2 4200+, 2 GB RAM, Debian testing/unstable
      kernel 2.6.20-rc1, Marvell SKGE onboard,
      filesystem 120 GB ext3 with default mkfs values on a SATA disk

After the writing stalls, I have echoed 't' into /proc/sysrq-trigger
and got a trace, which is at http://iucha.net/20-rc1/after.1.  There was
no oops before the trace request; the 'before' dmesg is at
http://iucha.net/20-rc1/before.1 .

Running 'top', one core is idle and the other is 99% waiting, while
the 'cp' program is in 'D' state.  Also, after NFSv4 stalls, invokations
of 'lsof' stall as well.  I can 'ssh' into the box without problems.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--56p9wBiXEyg+KhLM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF4oHsND0rFCN2b1sRAhcXAJ4g/UkLzh88W7p+6DH8FIlFaSnXlACeMZ+S
ne6RBoPHQugrLx3r6CY1BhY=
=unfz
-----END PGP SIGNATURE-----

--56p9wBiXEyg+KhLM--
