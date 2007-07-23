Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbXGWArb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbXGWArb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762931AbXGWArU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:47:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55986 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762809AbXGWArT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:47:19 -0400
X-Sasl-enc: D+kzSRaM9TcBmWKHxZP3LP4yswCIus/ZAROxYbhNff6b 1185151637
Message-ID: <46A3FBB7.9000608@imap.cc>
Date: Mon, 23 Jul 2007 02:52:07 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: g3vbv@blueyonder.co.uk, nix.or.die@googlemail.com
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc>
In-Reply-To: <46A3EC92.3050504@imap.cc>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig33389999E1204C81671130EE"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig33389999E1204C81671130EE
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

on Mon, 23 Jul 2007 01:47:30 +0200, /me wrote:
> On my test machine with a Pentium D 940 processor, Intel DQ965GF
> mainboard and SATA disks, kernel 2.6.22-git17 (32 bit build) fails
> to come up because it cannot find the disk drives. Same issue
> with a clone of the 'linus' git tree. Anything known?

Ok, scrap this. Turns out it wasn't a good idea to answer 'Y' to
the new XEN config option during "make oldconfig". After changing
it to CONFIG_XEN=3Dn, all's well again. Sorry for the noise.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig33389999E1204C81671130EE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGo/u3MdB4Whm86/kRAgjAAJ0eVDrJd3TFwA1ggJJLqg0zTyyXzwCfWzKc
SKZr/wPD+06OdOs1iR/AWFw=
=TMl9
-----END PGP SIGNATURE-----

--------------enig33389999E1204C81671130EE--
