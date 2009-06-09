Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZFINzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZFINzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZFINzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:55:22 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZFINzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:55:20 -0400
Subject: Re: linux-next: net/wireless tree build failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20090609233357.5d3801a0.sfr@canb.auug.org.au>
References: <20090609233357.5d3801a0.sfr@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SdA5J9/05dd6ih2RCURT"
Date: Tue, 09 Jun 2009 15:54:42 +0200
Message-Id: <1244555682.4672.7.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SdA5J9/05dd6ih2RCURT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 23:33 +1000, Stephen Rothwell wrote:

> Probably caused by commit 19d337dff95cbf76edd3ad95c0cee2732c3e1ec5
> ("rfkill: rewrite") which added uses of ERR_PTR to inlines in rfkill.h
> but did not include linux/err.h.

Indeed. Something must be including linux/err.h for me, I'll send a fix.

johannes

--=-SdA5J9/05dd6ih2RCURT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLmmeAAoJEODzc/N7+QmaM4MP/3qNo2XML9s6DgxKHDhEKfGn
8o1fPOp9VOIVfQF97YZNn/3Wf/nomqx0bgXnd4HJoYtBecuAvHX+7n0oBdc6DJMR
qLCI1i10bjSO6pY+hN3w2brGArnxXuzX1NddFdxYOwRx6bRD0c9CiVPrUvdyXodR
2BLwdukU+YSClQvV0oAxnJivNSgUNzOgRfePXyae1F9mLOtdSNrZPFfjcfeGtSL7
8wmuMpw/XVYwgXewSdGyyninyqGQ7dZSv0gzdCowsszh5Jo+F2eD0qebQ/AKRdTq
ns66NDiJo60a4D+isSI4rbe3behjD8FSKFeJZzOxLZHkE59/wp/C01QaNVsvHeOl
J4ua4UjWA7ztw2W3TRJWA/ogGsPthyVyTVL0tedvPXMONqD1Swo4YwyyntlckDJt
JoGD9EhG7ZaR7EMQ2lI9MGLJZ3Pm7F2FbPCLYiqoq0Dk09Io1bl5ohXry+7OV6i0
L8hkiYzQsCuqeD2ip4BMy59Q/CHxDeEBSTYQDX98WVQK0/JkMgo/U7YUMPpGIACx
t0CPCdoVIafKJ4e0OMG6FF91KsKFvzNQTXhxk9qXHak40PzF6Ri+x4iq+LCjrd9P
Up0tTNjRHl6VWuKc/62nrif7iAQcLK3t338TppqpWHZuW2bLyzZBeQ//zlPeOXni
IgLam7iLkpZIPIXf5JRz
=n9H0
-----END PGP SIGNATURE-----

--=-SdA5J9/05dd6ih2RCURT--

