Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbXKORGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbXKORGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760581AbXKORFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:05:55 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:47127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760246AbXKORFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:05:53 -0500
Subject: Re: [linux-pm] Re: [RFC][PATCH] Freezer: Make freezing failures
	less verbose by default
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071115002531.GA2343@ucw.cz>
References: <200711150038.07538.rjw@sisk.pl>  <20071115002531.GA2343@ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LivpPbX4Vmi1owsEXtAT"
Date: Thu, 15 Nov 2007 18:06:53 +0100
Message-Id: <1195146413.13846.82.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LivpPbX4Vmi1owsEXtAT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Currently freezing failures are extremely verbose which sometimes is
> > unnecessary and prevents the user from seeing which task could not be f=
rozen.

That's a good thing.

> I don't think compile time option is right thing to do.
>=20
> Dump just the stacks of the non-frozen tasks?

That's harder to do because there's no support right now.

> acpi_sleep=3Dverbose?

ewwww

> Reorder dmesg so that you get backtraces, and _then_ list of the
> tasks?

That'd be good too.

johannes

--=-LivpPbX4Vmi1owsEXtAT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzx8rKVg1VMiehFYAQLK8Q/+MPYv0/91Qq3TalzmlRxADN0Yb4jEWilB
hBEyH/5xUbOBgdmXHISCpYtwrmTnSpx8pZcvcmEw/9PUbGqLr7HM6Ec3zVqFYinh
N1rzjzmM/WalZHviTewVJHGvKTSZloxTT9O5PdLsj/hahKPz69c+gBGt/RoB/Gl/
fQD4nUGa0tRl5qEbm4l81yasdhVEXeGSbaBp9O6u5gG7Xzj6cWh/poCoM5wHcA+W
DRGt3fwC45GISx9wfKIBHYworTHaM01myQsTBT9ZxmXCYRw6A+WSFvi2f2TxqEEG
QvgLz+B5zboOT4yAXKzCsNcgPRuU+hrCKPGN+a/ftJh9rbqdVczh18BSL9fMukWi
g4qyQMI2t/2+nldRUw4ddKPSwc65SsRHeKKHs84Qrkmqk21Mh2+k8+2yzcuThCD1
NhU3t8tVIRxKU0Mcw3iouP/B1vvPZ6sb1H1C9/mUDcQVgHk3WVRFa2VewUO7uRAn
WQrss5+d/SM4w+tWoyaGXIHNXoxJaB2vdl0OKofUPtcC8SY/BbMjbRa6Qb1vHLTJ
Aprmnu6eOIt2td1XMgzt1dN3TisrqyyBko16U6m2dLygpKQxKLnP8a2mwMizLZP1
AwsaNtp+ciOBSrLc3U8pFHYaksvTBvs/i7lso+3BDB7Ru5AflDZSsKYMEpQkmv90
OtOWl4kZIeg=
=fNtl
-----END PGP SIGNATURE-----

--=-LivpPbX4Vmi1owsEXtAT--

