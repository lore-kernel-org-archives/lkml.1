Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbZJTPuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbZJTPuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 11:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZJTPuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 11:50:54 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50294 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbZJTPuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 11:50:54 -0400
X-Sasl-enc: XL0vEcssuo1vfVhTPipN8SNVcunt/aGWHwEzqPSlUBxo 1256053857
Message-ID: <4ADDDC55.8020809@imap.cc>
Date: Tue, 20 Oct 2009 17:50:45 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>
Subject: checkpatch.pl false positive? "ERROR: do not use assignment in if
 condition"
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7AAAEF9B9872D668CE9665E7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7AAAEF9B9872D668CE9665E7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

The command
=2E/scripts/checkpatch.pl -f drivers/isdn/gigaset/bas-gigaset.c=20
produces a lot of "ERROR" messages like these:

ERROR: do not use assignment in if condition
#608: FILE: isdn/gigaset/bas-gigaset.c:608:
+       if ((ret =3D usb_submit_urb(ucs->urb_cmd_in, GFP_ATOMIC)) !=3D 0)=
 {

ERROR: do not use assignment in if condition
#745: FILE: isdn/gigaset/bas-gigaset.c:745:
+               if ((ucs->rcvbuf =3D kmalloc(l, GFP_ATOMIC)) =3D=3D NULL)=
 {

ERROR: do not use assignment in if condition
#753: FILE: isdn/gigaset/bas-gigaset.c:753:
+               if ((rc =3D atread_submit(cs, BAS_TIMEOUT)) < 0) {

As far as I can see there's nothing wrong with these lines. In particular=
,
I cannot find anything in Documentation/CodingStyle that would prohibit a=
n
assignment inside an 'if' condition.

PS: I know the file has other problems. That's why I'm trying to
checkpatch it in the first place.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig7AAAEF9B9872D668CE9665E7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK3dxeQ3+did9BuFsRAlctAJ9mJKdvqge0R768ZJUzJreolgnblgCfVJu1
fyZKjunF5Jp1B1wSpAvkQUs=
=lYDR
-----END PGP SIGNATURE-----

--------------enig7AAAEF9B9872D668CE9665E7--
