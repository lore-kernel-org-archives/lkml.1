Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYFDKwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYFDKwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYFDKwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:52:08 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbYFDKwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:52:08 -0400
Subject: Re: [linux-pm] [PATCH] add a printk_init variant storing format
	strings in	__initdata
From: Johannes Berg <johannes@sipsolutions.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Andy Whitcroft <apw@shadowen.org>, mingo@elte.hu,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <1212571079.4042.66.camel@shinybook.infradead.org>
References: <20080529162257.03426e48.akpm@linux-foundation.org>
	 <1212485252.0@pinky> <20080604011607.15dec5a7.akpm@linux-foundation.org>
	 <1212569949.4042.56.camel@shinybook.infradead.org>
	 <1212570622.14371.19.camel@johannes.berg>
	 <1212571079.4042.66.camel@shinybook.infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iiRZEFidDKlbuGPL/ANX"
Date: Wed, 04 Jun 2008 12:51:08 +0200
Message-Id: <1212576668.14371.21.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iiRZEFidDKlbuGPL/ANX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-04 at 10:17 +0100, David Woodhouse wrote:
> On Wed, 2008-06-04 at 11:10 +0200, Johannes Berg wrote:
> > On Wed, 2008-06-04 at 09:59 +0100, David Woodhouse wrote:
> > > On Wed, 2008-06-04 at 01:16 -0700, Andrew Morton wrote:
> > > > We're going to want to be able to call printk_init() from modules.=20
> > > > Please fix and test that, if we decide to proceed.
> > >=20
> > > Can we fix that by making it an alias for printk in the module case?
> > >=20
> > > The only reason we need it to be __init is so that we get the section
> > > warnings when you use it from non-init code, right? Won't we get the
> > > warning when non-init code refers to the string in initdata anyway?
> >=20
> > In fact, wasn't the warning Andy showed such a warning?
>=20
> Hm, yes it was. Why do we need __printk_init() to be anything other than
> an alias for printk, then?

It looks to me like we wouldn't need it at all, just the printk_init()
macro that puts the format string into the right section.

johannes

--=-iiRZEFidDKlbuGPL/ANX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEZzm6Vg1VMiehFYAQLShQ//X4m7jDVmXmXB+kZPS9uC4/iZM9/g34yT
v4FsJ1v+Po+Cydi3dHO7oJvD0k5Y9VZyuYIWo2EjFaxsNSCwm40a1ZgkQf7n3+fx
sHmMrqEoX1UE7/1WUBuGej3zDxVduXmfdw+baGxs/5GFuiqTCcrWOTb4AJ2LasvY
lNnEtvyIb9UW5xlUl6y+B91ze+oOk24euMaUgApxB4/S9bjRTzp1BdlpS5bN1ei6
h2rvUdY63SOGJhgvZd2Gbf73UQAoWbE2VxO1UgGk3eBc90BhRYsJo/1kZc3yEj8G
YA5x8BGWOropweNDBZDTxWK6iDIPGEy+Q3FVC1NpqGNGvIC5qyjuWTiuIYErmuWp
qk1aNGZgTS8Jxd0kvUPerptek2EVIjkqWtuebWMUjITX4vO8JQe3LOvud4ubfGD8
98mhlQruLVTjNcWnZISnyzvZ4F/iu+KoA3BRNVjKgG+O2tluuah9YbXZk03vOf81
bAgo0bV8KBO1/CJBXWUptya+VrnPQLJBAKUrfyAzGPzhbvAsNDmlNthmWKXem2je
H8hi/gyhj30MntZ8aR70N0IuDV2MCkq7bc4Vw4NeUEc1TqEFao5w1IgdeDtYUfDf
2wKgFsjSCDTkel8r/xzecO79RyFpN/kXfezUroOvk+Vk9Oymu6c6Cop6aCmH2lOe
pexxYjz7d5E=
=uyc0
-----END PGP SIGNATURE-----

--=-iiRZEFidDKlbuGPL/ANX--

