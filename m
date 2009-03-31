Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZCaIPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZCaIPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZCaIOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:14:48 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52877 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbZCaIOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:14:46 -0400
From: Martin Steigerwald <Martin@Lichtvoll.de>
To: linux-fsdevel@vger.kernel.org
Subject: Replacing VFAT as filesystem on removeable media
Date: Tue, 31 Mar 2009 10:15:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, info@fsf.org, office@fsfeurope.org,
       info@linuxfoundation.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2228498.mSUDWKR0yX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903311015.29222.Martin@Lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2228498.mSUDWKR0yX
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi!

Now as TomTom appears to have surrendered to Microsoft and Microsoft seems=
=20
to have accepted this deal probably in order to not find out that their=20
patents are void, I think replacing VFAT as standard cross platform=20
filesystem on removeable media would be an even better idea than before=20
[1].

Granted I believe the patents will be made void one day, but even then I=20
think it would make sense to replace VFAT for technical reasons.

Such a filesystem IMHO should have the following features:
=2D cross platform with implementations for Linux, Windows, Mac OS X at=20
least, also the varios BSD variantes come to my mind
=2D open source
=2D probably some support for flash media without or with bad wear leveling
=2D some kind of journaling or other metadata consistency guarentee=20

People use ext2 as an alternative, but that lacks journaling.

I could also think of UDF with write support, but I am not sure whether=20
Windows and Mac OS X has write support.

Or probably even a new filesystem as long as people appear to write one=20
filesystem after another these days.

Or some kind of FAT *without* compatibility hacks, but I think this would=20
still be an inferior solution as long as it doesn't provide for metadata=20
consistency.

Maybe this could become some kind of Linux Foundation or FSF joint effort?=
=20
Together with advertising and advocacy of free software users this could=20
probably really replace VFAT in the long term.

What do you think? What other features would make sense to for such a=20
filesystem.

I am willing to test such a filesystem and help with documentation as well=
=20
as advocacy. But for coding I better start with something easier ;-).

[1]=20
http://www.h-online.com/open/TomTom-Microsoft-settle-patent-dispute--/news/=
112964

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2228498.mSUDWKR0yX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknR0SEACgkQmRvqrKWZhMeA9gCfb6gQ/BXx1/4Tk95di4t6n7hC
zkMAn0Z62SQPyuh6vtQ+X/BLdUtSUwLO
=POOF
-----END PGP SIGNATURE-----

--nextPart2228498.mSUDWKR0yX--
