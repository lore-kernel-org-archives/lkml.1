Return-Path: <linux-kernel-owner+w=401wt.eu-S965941AbXCPVKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965941AbXCPVKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965945AbXCPVKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:10:13 -0400
Received: from dilbert.robsims.com ([209.120.158.98]:49723 "EHLO
	mail.robsims.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965941AbXCPVKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:10:11 -0400
X-Greylist: delayed 1995 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 17:10:10 EDT
Date: Fri, 16 Mar 2007 14:36:45 -0600
From: Rob Sims <lkml-z@robsims.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andreas =?iso-8859-1?Q?Allg=F6wer?= <andreas.allgoewer@web.de>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>
Subject: Re: sky2 PHY setup
Message-ID: <20070316203645.GA24699@robsims.com>
References: <20070202102705.3cf028a6@freekitty> <20070202210934.GM1693@cip.informatik.uni-erlangen.de> <20070202151601.677ec5d9@freekitty> <20070203073012.GO1693@cip.informatik.uni-erlangen.de> <20070205090429.31d7bd32@freekitty> <20070222193611.GR20035@cip.informatik.uni-erlangen.de> <20070316002912.GB17594@cip.informatik.uni-erlangen.de> <20070316095932.5e920222@freekitty>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20070316095932.5e920222@freekitty>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2007 at 09:59:32AM -0700, Stephen Hemminger wrote:
> On Fri, 16 Mar 2007 01:29:12 +0100
> Thomas Glanzmann <thomas@glanzmann.de> wrote:
>=20
> > Hello Stephen,
> >=20
> > > yesterday I pulled from Linus tree because I saw the sky2 updated and=
 I
> > > tried to break it but it seems that my problems are gone. I let you k=
now
> > > if anything pops up in the future.
> >=20
> > bad news. I today tried the sky2 driver which is in Linus Kernel Tree
> > (HEAD) on a machine with very high network load and it stopped working
> > without any kernel messages after doing a flawless job under high load
> > for 5 hours. My watchdog rebooted the machine after 500 seconds. ;-(
> >=20
> >         Thomas
>=20
> I have run for 2+ days under load without problems. It is hard to
> reproduce or do much about your problem without more info.

Are there some debug hooks that can be activated?  My sky2 stops
responding (very light load) about twice a day.  The netdev watchdog
notices after a while and is able to reactivate the interface:

Mar 15 13:28:12 btd kernel: NETDEV WATCHDOG: eth0: transmit timed out
Mar 15 13:28:12 btd kernel: sky2 eth0: tx timeout
Mar 15 13:28:12 btd kernel: sky2 eth0: transmit ring 458 .. 435 report=3D45=
8 done=3D458
Mar 15 13:28:12 btd kernel: sky2 eth0: disabling interface
Mar 15 13:28:12 btd kernel: sky2 eth0: enabling interface
Mar 15 13:28:12 btd kernel: sky2 eth0: ram buffer 48K
Mar 15 13:28:15 btd kernel: sky2 eth0: Link is up at 1000 Mbps, full duplex=
, flow control both

This machine is a Core2 Duo e6700, and the interface is:
03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gi=
gabit Ethernet Controller (rev 20)
to 1 Gb hub.

On a Pentium 4, with:
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gi=
gabit Ethernet Controller (rev 15)
I have no issues, but with a very light network load, 100 Mb/s hub..

Each machine has two identical interfaces; only one has a cable in it.

Both machines can be used for testing/debug.
--=20
Rob

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+v/cnvKppSZW8osRApi7AJ0a8Fups2/NNoFZxOSHSF2X8w1wrgCffYff
gt/YnWALGVhLtwrtSRbRrbo=
=5Lbs
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
