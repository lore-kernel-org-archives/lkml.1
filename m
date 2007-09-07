Return-Path: <linux-kernel-owner+w=401wt.eu-S965802AbXIGO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965802AbXIGO3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965460AbXIGO3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:29:05 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965409AbXIGO3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:29:01 -0400
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>, satyam@infradead.org,
       flo@rfc822.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
       flamingice@sourmilk.net
In-Reply-To: <20070907142538.GC8864@linux.vnet.ibm.com>
References: <E1ITGb2-0006Be-00@gondolin.me.apana.org.au>
	 <1189085815.28781.78.camel@johannes.berg>
	 <20070906154612.GD8030@linux.vnet.ibm.com>
	 <1189171635.28781.134.camel@johannes.berg>
	 <20070907142538.GC8864@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4XdgTktjVHwooodKhzoa"
Date: Fri, 07 Sep 2007 16:30:15 +0200
Message-Id: <1189175415.28781.165.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4XdgTktjVHwooodKhzoa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 07:25 -0700, Paul E. McKenney wrote:

> > I don't like ASSERT_RTNL() much because it actually tries to lock it.
> > I'd be much happer if it was WARN_ON(!mutex_locked(&rtnl_mutex)) or
> > something equivalent.
>=20
> Ah!  It would indeed be nice to have a lower-overhead ASSERT_RTNL_LIGHT()
> or whatever.

I don't know why it tries that anyway. Maybe it's from semaphore days
where you couldn't check _is_locked()?

> > In any case, I have an updated patch I'll be sending soon, and it
> > requires a new list walking primitive I'll also send.
>=20
> Look forward to seeing it!

Will send in a minute.

johannes

--=-4XdgTktjVHwooodKhzoa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4WB3/ETPhpq3jKURAmOZAJ9TOGSuLJfpuooUTU6yWlbckOv5NACggVSj
Ken1ushUM1w6gKLvDZtlbCo=
=iT/x
-----END PGP SIGNATURE-----

--=-4XdgTktjVHwooodKhzoa--

