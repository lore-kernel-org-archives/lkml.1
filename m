Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbXIGTIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbXIGTIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXIGTIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:08:34 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbXIGTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:08:33 -0400
Subject: Re: [PATCH] list.h: add list_for_each_entry_continue_rcu
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Pavel Emelianov <xemul@openvz.org>, Zach Brown <zach.brown@oracle.com>,
       Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20070907153453.GD8864@linux.vnet.ibm.com>
References: <1189175688.28781.167.camel@johannes.berg>
	 <20070907153453.GD8864@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IkP2PUIw3XZk9Odxs8Gv"
Date: Fri, 07 Sep 2007 21:09:52 +0200
Message-Id: <1189192192.28781.182.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IkP2PUIw3XZk9Odxs8Gv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 08:34 -0700, Paul E. McKenney wrote:

> > + * Continue to iterate over rcu list of given type, continuing after
> > + * the current position.
>=20
> Please add something like the following to this comment:
>=20
> 	Note that the caller is responsible for making sure that
> 	the element remains in place between the earlier iterator
> 	and this one.  One way to do this is to ensure that
> 	both iterators are covered by the same rcu_read_lock(),
> 	while others involve reference counts, flags, or mutexes.

Sure, will do. Should this comment also be added to
list_for_each_continue_rcu()?

johannes


--=-IkP2PUIw3XZk9Odxs8Gv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4aIA/ETPhpq3jKURAiX0AJ9mnzmhkYKaVCBNW89nX9EhppgptgCdEOgX
T/8yyKeIw3gQQzI3yLfpkBU=
=gdRP
-----END PGP SIGNATURE-----

--=-IkP2PUIw3XZk9Odxs8Gv--

