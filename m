Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZCKJIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZCKJIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZCKJIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:08:21 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZCKJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:08:20 -0400
Subject: Re: Staging, place holder for better company/community development
	model
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <20090311050018.GB26202@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com>
	 <1236514065.4205.9.camel@johannes.local> <20090308223304.GB11513@kroah.com>
	 <1236583282.4205.71.camel@johannes.local>
	 <20090309194132.GB15011@kroah.com>
	 <1236633633.9658.23.camel@johannes.local>
	 <20090311050018.GB26202@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-an4RqtAbFsZr2+xeMzUm"
Date: Wed, 11 Mar 2009 10:08:11 +0100
Message-Id: <1236762491.9658.85.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-an4RqtAbFsZr2+xeMzUm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 22:00 -0700, Greg KH wrote:

> > Except it doesn't work for most of the wireless drivers you've sucked i=
n
> > without asking any wireless developers whether that makes any sense or
> > not.
>=20
> Any specific examples?

wlan-ng is the largest example, it's a load of crap, much of it being a
driver for hardware we already have drivers for, and the remaining
hardware being mostly unavailable these days. The driver served it's
purpose at a time, but the authors had years and years of time to bring
it in and never bothered. It needs to be incorporated into a
rearchitectured orinoco driver, or so.

I also remember objecting to rt2860/rt2870, and the only good thing that
has come out of adding those is a spatch that might otherwise not have
been applied to those drivers. Afaict, no new people have helped with
rt2800, the rt2x00 based driver for this hardware, because they've come
in contact with rt2860/rt2870.

I don't remember any discussion about rtl8187se either.

All of those bring their own 802.11 stack, and changing to the Linux one
will /necessarily/ require an entire rewrite of the drivers because the
stacks operate /completely/ differently. Even the clean, in-kernel
bcm43xx driver was rewritten to b43 for mac80211, and rtl8187se ships
the old ieee80211_softmac code that I and a few others wrote...

johannes

--=-an4RqtAbFsZr2+xeMzUm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJt394AAoJEKVg1VMiehFYgGAP/0H7PGzrI/hJaRpCmf9fWPJY
UKq5yP8xHeCcH/AIGyWCMF1+jZJO5o94IWNxNV0xr9Eu4R2+Mxm4np3Da53cCled
gTDu6g1pGc4aw01K6EdQmnIQt5fFEQxKwKmarLI965LdLYGmSI5HjDXs16sm3ml7
+4v2/wAGIKNFhTqIt7KlNO6w6/vS0HV3tnpVRzuJKlr3lo6RYMVSat81wVQX6/P8
tpbZ0AzXsn0MwcsOQKgSXbRFDmhKZDObfAnKa5d/uajCdW4ZAI1RC0KZyYSPji3x
RBTYM7Se2lyCtnDdUum8Hzu53teXy8dcI0nN+vN+UCSZiTLXVIkkTEwGtP8uTBxN
X3M8Mcl1nBldFZysleaxtxx+eQeSGhiLQs8duCVRk4uDwrj3q4ZCBUFZWLNgiX5U
oCBysGpugpI8aSiVhaYxqeyTXG9EFcpNJVI/MGiyINAWDzWuqNTrk+e4YmBLTMXO
MZDJp5MRfrHrUmLxMUgsOguTMQ15+oG7ThfC3Ki1OVVwOFMA11o0YO7DhOPBB5R4
BSIHsa8KM5CnjcgV1ZecMsFL04Z3ZMutERrHh4a6fmuBNL1RcmPDrJwpVBBOaXa6
f87C+0xg/iZaw5wb5iH0vervS9ejfYNsu+PSd8qwA3JY8/dfgcNlPP/L8S1UXQN+
gMfpgi5KGth9d+OqfTyY
=NZME
-----END PGP SIGNATURE-----

--=-an4RqtAbFsZr2+xeMzUm--

