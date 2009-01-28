Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZA1LAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZA1LAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbZA1K7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:59:53 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:47372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZA1K7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:59:52 -0500
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233137581.10992.44.camel@laptop>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop>
	 <1233082650.4455.9.camel@johannes.local> <1233130815.10992.39.camel@laptop>
	 <1233136487.4151.5.camel@johannes.local> <1233137581.10992.44.camel@laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xL06xUh/SPtuSsYtceLe"
Date: Wed, 28 Jan 2009 11:54:41 +0100
Message-Id: <1233140081.3936.21.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xL06xUh/SPtuSsYtceLe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 11:13 +0100, Peter Zijlstra wrote:
> On Wed, 2009-01-28 at 10:54 +0100, Johannes Berg wrote:
> > On Wed, 2009-01-28 at 09:20 +0100, Peter Zijlstra wrote:
> > > On Tue, 2009-01-27 at 19:57 +0100, Johannes Berg wrote:
> > > > This modifies the timer code in a way to allow lockdep to detect
> > > > deadlocks resulting from a lock being taken in the timer function
> > > > as well as around the del_timer_sync() call.
> > > >=20
> > > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > >=20
> > > Nice, thanks!
> >=20
> > I actually got "trying to register non-static key" on my powerpc64
> > machine. Is there a possibility that functions are not static??
>=20
> Hmm, weird, afaict static_obj() includes both text and data, for the
> core kernel as well as modules.

Yeah, I'd think it should. I'll run it by the powerpc list when I get it
again, it only seems to happen very rarely.

johannes

--=-xL06xUh/SPtuSsYtceLe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgDluAAoJEKVg1VMiehFYJ34P/iGc62c0OPnqeKu/DHWSC6Lz
pwJlNB3JlP94bC+3D+FsOsXpX04JEsDQKQyVoMq2AsN88XqINN5WMnfkiNlqvqWd
bKAaCjuGDj07uj2DseGR067+D3VpY3dwuAKukf69bARSSGhfhBy7MaqZYp6Y0/JY
1t3jI7I2X30uDJB//xoigcA8zGri+0tM94jECj5XflZ9r+HlVXjrKg7idXtw3/bv
hoLlKUmXfL88wL0E6/xG5lp3SX4AFsoiOCPwa2uhMeYX59I9WzuA2hHMDxIPRL9V
Otl2eRabfyS2EUyTXLfu1EIdCuqiXyvaoWFTUY2RUW7mswaWRKAE+5vf7zZo8tQ7
TSPYO1eeSQ6ofZ/188viVUZAjqE673bXVl7BtyerdsEew71rcDadN9Pi+SrXIt7x
8hM+dLKKQR8lQsTYtVgu1f59VSgthsGdPWCUGCWYiX/Dq52NzwLrc1FjbrKDKmeA
ZcJ42LX5ECsdwxRthuGplcOMlfZWQbsSlujmVjeucFq5nZGi5Td/ug/Hzwvx+m8c
eMeWRKjNZJETkrPg9Xt5r4NT/N74VXeCdI3gYgW6SEkU7HsrvTVtNQ96gqymup7d
uJqJCJv90t9CgkoHkCgCoTty2Pr23y775gF8NGyJdk+QgFfUE+XlgXLVunEMJ3Pq
EfEkO/j6T3apGrFIe+gC
=SYEP
-----END PGP SIGNATURE-----

--=-xL06xUh/SPtuSsYtceLe--

