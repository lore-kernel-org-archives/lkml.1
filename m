Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXEFUWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXEFUWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbXEFUWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:22:37 -0400
Received: from dilbert.robsims.com ([209.120.158.98]:34416 "EHLO
	mail.robsims.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbXEFUWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:22:35 -0400
Date: Sun, 6 May 2007 14:22:34 -0600
From: Rob Sims <lkml-z@robsims.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andreas =?iso-8859-1?Q?Allg=F6wer?= <andreas.allgoewer@web.de>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>
Subject: Re: sky2 PHY setup
Message-ID: <20070506202234.GB17957@robsims.com>
References: <20070203073012.GO1693@cip.informatik.uni-erlangen.de> <20070205090429.31d7bd32@freekitty> <20070222193611.GR20035@cip.informatik.uni-erlangen.de> <20070316002912.GB17594@cip.informatik.uni-erlangen.de> <20070316095932.5e920222@freekitty> <20070316203645.GA24699@robsims.com> <20070316141648.15d7ff75@freekitty> <20070327032406.GA25659@robsims.com> <20070404111930.46321146@freekitty> <20070407175348.GB18457@robsims.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <20070407175348.GB18457@robsims.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 07, 2007 at 11:53:48AM -0600, Rob Sims wrote:
> On Wed, Apr 04, 2007 at 11:19:30AM -0700, Stephen Hemminger wrote:
=2E..=20
> > You might have over run the hub and it wedged.  Try doing:
> > 	ethtool -r eth0
> > that forces a down/up
>=20
> I'm still seeing throughput drop to under 1 Mb/s (50-100kB/s)
> periodically.  I did an ethtool -S and ethtool -d to capture state.
> (sky2-fail.log).  I ran ethtool -r and retested; no change
> (sky2-ethtool-r.log).  Finally, ifdown - rmmod - modprobe - ifup, which
> restored to Gigabit speeds (96+ MB/s), (sky2-modcycle.log).
>=20
> Please let me know if there's anything else I can poke into.  As a
> reminder, this is a 88E8053 r20.  Next time I see a degradation, I'll
> try cycling the switch.

I continued to have problems with this interface.  I tried bringing up
the second interface on the motherboard; I added a cable to the same hub
as the first interface and configured an address on the same subnet.
I intended to see if I could use it as a redundant interface for when
the first hung.  I haven't been able to test that, because now I haven't
seen a hang or slowdown since I brought the second interface up. =20

Could the idle interface have generated an interrupt which is never
cleared because the interface is down?  Or something similar?
--=20
Rob

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGPjkKnvKppSZW8osRAlBrAJ42L/v9igGfQBmHu2vxVsUuzyfvowCfQZvZ
dgaUv/4poMV4E8u1yoZf28M=
=H28D
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
