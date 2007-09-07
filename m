Return-Path: <linux-kernel-owner+w=401wt.eu-S965860AbXIGOeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbXIGOeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965482AbXIGOek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:34:40 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965427AbXIGOei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:34:38 -0400
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IdO4tpi0nZG8DJ8ISM4+"
Date: Fri, 07 Sep 2007 16:35:59 +0200
Message-Id: <1189175759.28781.169.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IdO4tpi0nZG8DJ8ISM4+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 07:25 -0700, Paul E. McKenney wrote:

> > > > @@ -226,22 +225,22 @@ void ieee80211_if_reinit(struct net_devi
> > > >  		/* Remove all virtual interfaces that use this BSS
> > > >  		 * as their sdata->bss */
> > > >  		struct ieee80211_sub_if_data *tsdata, *n;
> > > > -		LIST_HEAD(tmp_list);
> > > >=20
> > > > -		write_lock_bh(&local->sub_if_lock);
> > >=20
> > > This code is also protected by RTNL?
> >=20
> > Yes.
>=20
> Comment?  (Or is it in the function header?)

Oh, forgot to say: yes, there is a comment further up and even an
ASSERT_RTNL()

johannes

--=-IdO4tpi0nZG8DJ8ISM4+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4WHP/ETPhpq3jKURAr3DAKCDiqVlmDTgtNA0MrlPeedNvxUItACgnz5U
LagOxuLcia2E1MN7EXK3TPA=
=f/3v
-----END PGP SIGNATURE-----

--=-IdO4tpi0nZG8DJ8ISM4+--

