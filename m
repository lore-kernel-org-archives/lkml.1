Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZDOOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZDOOCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZDOOCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:02:05 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3321 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbZDOOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:02:04 -0400
Message-ID: <49E5E8D0.1090505@imap.cc>
Date: Wed, 15 Apr 2009 16:01:52 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Kconfig Q: expressing a modularity dependency
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig920103BF38F6B050F1BCC328"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig920103BF38F6B050F1BCC328
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

My current attempts to port the Gigaset driver from isdn4linux
to CAPI require the following Kconfig dependency:

- If isdn4linux or kernelcapi or both are built as a module
  (CONFIG_ISDN_I4L=3Dm || CONFIG_ISDN_CAPI=3Dm)
  then gigaset can only be built as a module
  (CONFIG_ISDN_DRV_GIGASET depends on m).

- If neither isdn4linux nor kernelcapi ar built as a module
  (CONFIG_ISDN_I4L!=3Dm && CONFIG_ISDN_CAPI!=3Dm),
  including the case that neither is being built at all
  (CONFIG_ISDN_I4L=3Dn && CONFIG_ISDN_CAPI=3Dn),
  then gigaset may be built statically or as a module
  (all three tristate settings for CONFIG_ISDN_DRV_GIGASET are
  legal).

How is that best expressed in Kconfig?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig920103BF38F6B050F1BCC328
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJ5ejZQ3+did9BuFsRAm3QAJ9a/HT9+61pjjSPgQxGwLkvNQHhewCbBlam
IRwdCzt2ZdOs0uzJe4YeU24=
=zR0U
-----END PGP SIGNATURE-----

--------------enig920103BF38F6B050F1BCC328--
