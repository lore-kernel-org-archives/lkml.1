Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXL1AvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXL1AvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXL1Au7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:50:59 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52974 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbXL1Au6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:50:58 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
Date: Thu, 27 Dec 2007 19:49:01 -0500
User-Agent: KMail/1.9.7
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Paul Mundt <lethal@linux-sh.org>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
References: <1198774339.6170.11.camel@localhost.localdomain> <1198796281.4833.31.camel@localhost>
In-Reply-To: <1198796281.4833.31.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1620347.NXWMkVdv5Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712271949.02942.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1620347.NXWMkVdv5Z
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 27 December 2007, Joe Perches wrote:
> On Thu, 2007-12-27 at 16:52 +0000, Adrian McMenamin wrote:
> > This patch adds support for the CD-Rom drive on the SEGA Dreamcast.
>
> Because it was already so close, might as well make it checkpatch clean.

for the 80 col limit, that's up to the author.  if Adrian is happy with it =
as=20
is, that's fine.

> I also added a function gdrom_is_busy() to make a couple of tests
> fit on a single line and perhaps easier to read.

i'd tend to agree it does make it easier to read, however you didnt make it=
=20
inline which means gcc may not inline it which means there's pointless=20
overhead of doing a function call.

otherwise, arbitrary breaking on 80 cols actually makes the code harder to=
=20
read for no gain.
=2Dmike

--nextPart1620347.NXWMkVdv5Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iQIcBAABAgAGBQJHdEf+AAoJEEFjO5/oN/WBg0QQAMXtMlJ8mZx5ZunuBJZm0S9f
CCXzQIdDdeTiVhWRjELWD9DLjZckxVn9XUOKwKh1S+Q1cDXUXbtpL0QA/ipzRmq0
tR1yzJCrkXvr5847oevEiyXjgwAGsCVZaSor1tv6/vrfUaiOO21WGtAEoh8v0mxx
MmFgei+0nHvS88WpGfj6dPDFStBBj+mAHweyO348VK+QCv4Sv4WTwURsc5f2BZ9B
uoIQt9txFUAKaEe1sRDGiXxYK24AKNk8mmf91ioXEnJpPj5HJC2j+iQkiocba7uN
Fo16MBj2/npjbnz1sq5ZR0WS5kUDwHT4ksPxYRD7YVpviTRn8nCIxwKSUbx6qdb7
n3x9qjlipsNqGGro2ooBXJTm4bEAVUSi1Iezcar4kOWwOLUcGbIaXZxnI6qf91DM
DXZtom1G7XuAfaPgkSj7ssd7ChTnXorUkFksdicxrZNMwBxE6Sd9LAJCv8Cttehf
zPVHndfVBtIcXGNbXCH6ni1lTgMZlhpIkUxh07xV83zt7qx0bah/fz+tBjiJsWvq
RSQGzDUviL1/nZZCE+yjxMa5AXOnaqGjwdBqiY6ENzAoyYvEGODiK9O7umD1UYAz
p8eoBuIcVRhwQNJrvieZMFc7bg/W7V3Bbnm6pyxck1JwlFaUoqZxFdTGd4+BE0oZ
S69TkVEGQdycrNIVhp6j
=MvCa
-----END PGP SIGNATURE-----

--nextPart1620347.NXWMkVdv5Z--
