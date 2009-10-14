Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZJNS2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZJNS2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZJNS2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:28:09 -0400
Received: from k66.ru ([87.224.128.21]:61494 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017AbZJNS2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:28:08 -0400
Date: Thu, 15 Oct 2009 00:27:29 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: drivers/staging/rt2860 doesn't compile
Message-ID: <20091014182729.GC19095@wrars-comp.wrarsdomain>
References: <20091014063824.GD6298@wrars-comp.wrarsdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
Content-Disposition: inline
In-Reply-To: <20091014063824.GD6298@wrars-comp.wrarsdomain>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-06-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Even after trivial fix (including <linux/sched.h> into
drivers/staging/rt2860/rt_linux.h) the driver doesn't compile:

drivers/staging/rt2860/rt_main_dev.c: In function 'rt_ieee80211_if_setup':
drivers/staging/rt2860/rt_main_dev.c:691: error: 'struct net_device' has
no member named 'wireless_handlers'

--=20
WBR, wRAR (ALT Linux Team)

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJK1hgRAAoJEOih81koZvPBopcH/0fmWr0X3kabO090rFEKT1AW
4Aenlyzvvljr4GRHGhLVBQ367H7WxXbn6nOP02gQ6KQ1c7sw5G8f8zN/Rq5Xpx4I
n4393ggE/FZCoT5RilwSdXizdsiwcCqKOEkFjjKjlC5jCb8n57iVKfCPeAwZD6hn
DvLaB6RvyUe0QSSPRqBAP6H+XBhTHo1Up3rGqEVkxt3VJgbBSvwWT3TYZqbaCuq/
C85k1gtyQjfihOG+6NGHyaCNxWY3Gq4Nv1lWuCmhdYYJQAFMrbOlxPtMs6S7vxis
dkp8OSeYjwl+w9j1t2mSDGqUJphKQCMSpOXfS4dwwmzJtkKQTvLIiYyy+hxUJeo=
=rSGr
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
