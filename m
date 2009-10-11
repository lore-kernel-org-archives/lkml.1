Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZJKLCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZJKLCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 07:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZJKLCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 07:02:19 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37224 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647AbZJKLCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 07:02:18 -0400
X-Sasl-enc: zlPar8/niqHhSpfoXGtBz5in2qnrRAubMCyiYuqSULdP 1255258899
Message-ID: <4AD1BB06.70309@imap.cc>
Date: Sun, 11 Oct 2009 13:01:26 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>,
       Andy Walls <awalls@radix.net>
Subject: Re: checkpatch is not detecting bad whitespacing when using macros
 on formulas
References: <20091011071911.54347f2b@pedra.chehab.org>
In-Reply-To: <20091011071911.54347f2b@pedra.chehab.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4F70A0D95EF06F1FB27C8A0B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4F70A0D95EF06F1FB27C8A0B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Mauro Carvalho Chehab schrieb:
> While reviewing a patch from Andy Walls, I noticed that checkpatch v 0.=
29
> didn't get any errors when bad whitespacing is used on some formulas:
>=20
> $ checkpatch.pl cx23888-ir-part2_2.patch
> total: 0 errors, 0 warnings, 1237 lines checked
>=20
> cx23888-ir-part2_2.patch has no obvious style problems and is ready for=
 submission.
>=20
> However, there are several places at the patch like:
>=20
> +static inline u16 ns_to_clock_divider(unsigned int ns)
> +{
> +       return count_to_clock_divider(
> +                 DIV_ROUND_CLOSEST(CX23888_IR_REFCLK_FREQ/1000000 * ns=
, 1000));
> +}

checkpatch is already complaining too much rather than too little.
No need to add even more complaints.

The code you cite above is fine IMHO, but if you don't like it, feel
free to raise your complaints. You can do so without help from
checkpatch, too.

Jm2c
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4F70A0D95EF06F1FB27C8A0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK0bsPQ3+did9BuFsRAgVLAJ9J+Rl457F086CZYnkJrAtjgr0YNgCfepyX
KJs+oBuyCREi4X7vndjj+oY=
=UAih
-----END PGP SIGNATURE-----

--------------enig4F70A0D95EF06F1FB27C8A0B--
