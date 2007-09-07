Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbXIGUDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbXIGUDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 16:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXIGUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 16:03:26 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXIGUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 16:03:25 -0400
Subject: Re: [PATCH] list.h: add list_for_each_entry_continue_rcu
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Pavel Emelianov <xemul@openvz.org>, Zach Brown <zach.brown@oracle.com>,
       Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20070907195741.GG8864@linux.vnet.ibm.com>
References: <1189175688.28781.167.camel@johannes.berg>
	 <20070907153453.GD8864@linux.vnet.ibm.com>
	 <1189192192.28781.182.camel@johannes.berg>
	 <20070907195741.GG8864@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yAuduP0KzZirt3mHyegm"
Date: Fri, 07 Sep 2007 22:04:55 +0200
Message-Id: <1189195495.28781.200.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yAuduP0KzZirt3mHyegm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 12:57 -0700, Paul E. McKenney wrote:

> Actually, list_for_each_continue_rcu() needs to be removed in favor of
> your new list_for_each_entry_continue_rcu().  There are currently only
> two users as of 2.6.22.  One of them immediately does a list_entry(),
> and the other would convert easily as well.  So please let me know
> when this gets accepted!  ;-)

Heh, ok, I won't add the text to that macro if you want to remove it
anyway. I guess I'll add your paragraph and ... hmm. what do I do with
it? Who's responsible for list.h? Can I push this through John Linville
and Dave Miller so I can get the fix into his tree easily without
synchronisation?

johannes

--=-yAuduP0KzZirt3mHyegm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4a7n/ETPhpq3jKURAsyZAJ9741PgHOHePEtyKpcfkyGcubDrJwCfav8U
9rAomjcP4LGN89dHEReF/XE=
=5SF/
-----END PGP SIGNATURE-----

--=-yAuduP0KzZirt3mHyegm--

