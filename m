Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYDNBss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYDNBss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYDNBsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:48:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55774 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbYDNBsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:48:39 -0400
Date: Mon, 14 Apr 2008 11:48:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       David Miller <davem@davemloft.net>
Subject: Re: linux-next: Tree for April 10: generic pci_enable_resources()
 strikes again
Message-Id: <20080414114823.b20802fe.sfr@canb.auug.org.au>
In-Reply-To: <200804102134.00997.m.kozlowski@tuxland.pl>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
	<200804102134.00997.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Apr_2008_11_48_23_+1000_acxi8a.L+.7bU1Tm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Apr_2008_11_48_23_+1000_acxi8a.L+.7bU1Tm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 10 Apr 2008 21:34:00 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.p=
l> wrote:
>
> 	The commit b818da52 makes my sparc64 box simply unable to boot.
> You should probably take a look at other arches as well. The story is her=
e:
>=20
> http://lkml.org/lkml/2008/3/28/465
> http://lkml.org/lkml/2008/4/1/248

This patch has remained unchanged since first imported into linux-next in
March 6.

So, the question is: What are the consequences of reverting it?  I am not
in a position to judge, but if it causes boxes to simply not boot, then
it would be a major regression in 2.6.26 and simply cannot be included
there.

I will revert it at the end of today's tree and hope that there is some
resolution before the merge window opens.

Of course, there is still the question of the other architectures ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Apr_2008_11_48_23_+1000_acxi8a.L+.7bU1Tm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIArfzTgG2atn1QN8RAjdpAJ9Wd1V6igl8kGwW9DGfkG2wnnYGdACfW0Sn
yUpC/21oeIESe9BjophmOaA=
=TPhJ
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Apr_2008_11_48_23_+1000_acxi8a.L+.7bU1Tm--
