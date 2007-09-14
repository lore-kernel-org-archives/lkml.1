Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXINVNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXINVNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbXINVNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:13:44 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:56145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbXINVNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:13:43 -0400
Subject: Re: [PATCH] list.h: add list_for_each_entry_continue_rcu
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070910173948.GD11801@linux.vnet.ibm.com>
References: <1189425947.4506.78.camel@johannes.berg>
	 <20070910173948.GD11801@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kHBSp+enM3bXtGDNGfS7"
Date: Fri, 14 Sep 2007 23:14:58 +0200
Message-Id: <1189804498.3974.57.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kHBSp+enM3bXtGDNGfS7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 10:39 -0700, Paul E. McKenney wrote:
> On Mon, Sep 10, 2007 at 02:05:47PM +0200, Johannes Berg wrote:
> > To implement the multicast list callback in mac80211 we need to
> > do partial list iteration. Since I want to convert the interface
> > list to an RCU list, I need a new list walking primitive:
> > list_for_each_entry_continue_rcu().

Hah. Turns out if I do the right thing with dev_mc_sync() I no longer
need this. Paul, do you want to push it to akpm or such? My bugfix no
longer relies on it.

johannes

--=-kHBSp+enM3bXtGDNGfS7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6vnS/ETPhpq3jKURAuDGAJ48aLM5KILpfEdw5Kp2hQgejTv5TgCgg243
/5U9NvahgE2nioPW+WYJ2ZM=
=EXs9
-----END PGP SIGNATURE-----

--=-kHBSp+enM3bXtGDNGfS7--

