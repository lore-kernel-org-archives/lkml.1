Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbYBUUJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbYBUUJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYBUUJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:09:40 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:41138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbYBUUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:09:38 -0500
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080221200620.GA29352@uranus.ravnborg.org>
References: <1203503909.17534.14.camel@johannes.berg>
	 <20080220195913.GE21139@uranus.ravnborg.org>
	 <1203597776.20331.5.camel@johannes.berg>
	 <20080221200620.GA29352@uranus.ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OCH9JPRH6PK4hPQ9IIY+"
Date: Thu, 21 Feb 2008 21:09:23 +0100
Message-Id: <1203624563.26341.15.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OCH9JPRH6PK4hPQ9IIY+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > In any case, I would love to have __CHECK_ENDIAN__ enabled by default a=
t
> > least on the wireless code (just caught another bug with it...)
>=20
> I should then add support for something like:
>=20
> checkflags-y :=3D -D__CHECK_ENDIAN__
>=20
> to match the style of the rest.
>=20
> I do not like all the buried in assumption about the
> global variables.

That might be good. I retract my patch for now then.

> But I would prefer that someone would spend a few days looking into the
> warnings generated with sparse.

I did spend a bit of time running it on all the tree, but wireless,
where I do most work, is clean. I have some code in sound/ that
generates warnings and some drivers/macintosh/ code I worked on too, but
right now I don't want to pick up too many changes all over the tree
into my patches tree.

johannes

--=-OCH9JPRH6PK4hPQ9IIY+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR73acqVg1VMiehFYAQIlZhAAsg4i2IqFy6o3Lly2uSAq/Fs14WJHsSSO
0BxODgIPezUwKzmqi/1UIu1EeNJnOdkst8ORo/+BJL5OzX6eVPSofilfCgSVORRs
T5RI6tGM7gqaJR32DvIiA21dNH3UkycagjyNwgl7o0Or4tSItnHmInqliU0GYHcg
Vnvf0dSTYeCF47d3XmTHJ27C6i8QGBsvRCLLpfZMFooauh36XFgE5rna70LTxL1p
Xajb/Z3iDa7k1nYA6QF+AKQoodlO8qrrjWzGNnkdL4Mw9Fzera6oZWuNCdmHputJ
+HD9oxj0HSyBB1PcODcme1TEoU2n03W6tuYpOCqDFcYLCMyvxRnK/MGNcWWb4eGO
g/yUOEQiftGGh2jfq03yB/0/4o9vlUBgs88ikNJMzdntK60mUK2EM/+6VVN24UKp
55QOV1SGy140WFIyXkJY/jCT5UrM+DJMzROlECqutE+Xq/1iBQ1s5noc18vf4zuJ
SJmVTvwVbw8V5yRMsD4eZ5X31QRaV0syQbMSEgqO2PbjbcPUrteF2BsjhMOE9NFF
U+LiuFVO7eRPb9nTVUBG5mD+4rDx3gkM1G6WcwrveW86SkBaVSD/nZj8CMpsgbYb
keGhQAqi8SWAd8nBaC/Vjj0q9WtLnZyEP71uZJAH/Sp9ez/Q9EFqyNJADRyLjOQ+
aXEObxZmfM4=
=re5m
-----END PGP SIGNATURE-----

--=-OCH9JPRH6PK4hPQ9IIY+--

