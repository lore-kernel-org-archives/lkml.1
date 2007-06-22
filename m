Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbXFVRir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbXFVRir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbXFVRik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:38:40 -0400
Received: from iucha.net ([209.98.146.184]:39263 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbXFVRik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:38:40 -0400
Date: Fri, 22 Jun 2007 12:38:39 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "upping" a semaphore from interrupt context?
Message-ID: <20070622173839.GB8398@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I am writing a USB driver for some custom hardware, and I need to
synchronize between the user-space and the USB subsystem.  Can I
create a semaphore and "down" it in the reader then "up" it in the
completion handler?

I know the completion handler runs in interrupt context so you are not
allowed to acquire any semaphores: but can you release them?  Will the
waiting tasks wake up after the handler and its caller returned - IOW
will the waking up task run in interrupt context as well?

This is with Linux 2.4 (if it makes a difference).

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGfAkQND0rFCN2b1sRAkirAKCGBvXAECuF+YDjdR/qYy8xGG7r5gCeLF5P
hdRJZzFVMot62SxE2qKiLtw=
=gqqX
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
