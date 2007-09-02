Return-Path: <linux-kernel-owner+w=401wt.eu-S965127AbXIBQMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127AbXIBQMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 12:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbXIBQMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 12:12:37 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:47620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbXIBQMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 12:12:36 -0400
Subject: Re: RTNL: assertion failed at net/core/dev.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <alpine.DEB.0.999.0709021754290.7103@sheep.housecafe.de>
References: <alpine.DEB.0.999.0709021754290.7103@sheep.housecafe.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PpNu+qoJvafitV2emGie"
Date: Sun, 02 Sep 2007 18:13:48 +0200
Message-Id: <1188749628.4028.6.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PpNu+qoJvafitV2emGie
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-09-02 at 18:05 +0200, Christian Kujau wrote:
> but given the amount of changes currently=20
> going into net/ I thought this might be interesting:
>=20
> [15604.137408] RTNL: assertion failed at net/core/dev.c (2595)

> [15604.138807]  [<c038c612>] __dev_set_promiscuity+0xc2/0xd0
> [15604.139163]  [<c038c9bb>] dev_set_promiscuity+0x1b/0x40
> [15604.139515]  [<f91cb3fb>] VNetBridgeStartPromisc+0x2b/0x50 [vmnet]

Not sure why this would be interesting. Clearly, dev_set_promiscuity is
called without the RTNL held while it should be. And see who the caller
is?

johannes

--=-PpNu+qoJvafitV2emGie
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2uE8/ETPhpq3jKURAgySAJ98fNj90GDGG64ANwIHCJLXfpG6wQCeOQle
6laOJ4yQIOQyOBNNADc1Mg8=
=Ye+P
-----END PGP SIGNATURE-----

--=-PpNu+qoJvafitV2emGie--

