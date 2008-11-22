Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYKVCYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYKVCYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbYKVCYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:24:11 -0500
Received: from 173-8-135-49-SFBA.hfc.comcastbusiness.net ([173.8.135.49]:49868
	"EHLO sandall.us" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYKVCYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:24:10 -0500
Date: Fri, 21 Nov 2008 18:24:06 -0800
From: Eric Sandall <eric@sandall.us>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27.6
Message-ID: <20081121182406.15099990@sandall.us>
In-Reply-To: <20081119061558.GB4332@suse.de>
References: <20081113185350.GA3765@kroah.com>
	<20081118092051.53d1fcc2@sandall.us>
	<20081119061558.GB4332@suse.de>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/iMFV9Et6D13_RbeU+Ukbifu";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iMFV9Et6D13_RbeU+Ukbifu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Nov 2008 22:15:58 -0800
Greg KH <gregkh@suse.de> wrote:

> On Tue, Nov 18, 2008 at 09:20:51AM -0800, Eric Sandall wrote:
> > On Thu, 13 Nov 2008 10:53:50 -0800
> > Greg KH <gregkh@suse.de> wrote:
> > > We (the -stable team) are announcing the release of the 2.6.27.6
> > > kernel.
> > >=20
> > > It contains a wide range of bugfixes, and all users of the 2.6.27
> > > kernel series are strongly encouraged to upgrade.
> > >=20
> > > I'll also be replying to this message with a copy of the patch
> > > between 2.6.27.5 and 2.6.27.6
> > > Francois Romieu (3):
> > >       r8169: get ethtool settings through the generic mii helper
> > >       r8169: fix RxMissed register access
> > >       r8169: wake up the PHY of the 8168
> >=20
> > My r8169 no longer compiles:
> > ...
> >   Building modules, stage 2.
> >   MODPOST 243 modules
> > ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> >=20
> > Attached my .config. Also tried witht he following changed, with the
> > same results:
> > +CONFIG_NET_ETHERNET=3Dy
> > +CONFIG_MII=3Dm
>=20
> Already fixed in 2.6.27.7-rc2.

Compiles and works in 2.6.27.7 stable release, thanks. :)

-sandalle

--=20
Eric Sandall                     |  Source Mage GNU/Linux Developer
eric@sandall.us PGP: 0xA8EFDD61  |  http://www.sourcemage.org/
http://eric.sandall.us/          |  http://counter.li.org/  #196285

--Sig_/iMFV9Et6D13_RbeU+Ukbifu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkknbUYACgkQHXt9dKjv3WGQUgCgs6v1h7A2GRqa0XLMyEnGU7ks
DDMAn06mlWPqwnm1fcYuD0vvGDkuHkTK
=r4QI
-----END PGP SIGNATURE-----

--Sig_/iMFV9Et6D13_RbeU+Ukbifu--
