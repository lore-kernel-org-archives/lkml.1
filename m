Return-Path: <linux-kernel-owner+w=401wt.eu-S966260AbXG3Dbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966260AbXG3Dbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 23:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936764AbXG3Dbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 23:31:40 -0400
Received: from dilbert.robsims.com ([209.120.158.98]:35863 "EHLO
	mail.robsims.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbXG3Dbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 23:31:39 -0400
X-Greylist: delayed 1808 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2007 23:31:39 EDT
Date: Sun, 29 Jul 2007 21:01:30 -0600
From: Rob Sims <lkml-z@robsims.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Kyle Rose <krose@akamai.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070730030130.GA6893@robsims.com>
References: <46A8BAD4.8020004@akamai.com> <20070726165701.GM3572@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20070726165701.GM3572@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 26, 2007 at 06:57:01PM +0200, Adrian Bunk wrote:
> On Thu, Jul 26, 2007 at 11:16:36AM -0400, Kyle Rose wrote:
> > >From http://www.krose.org/~krose/computing.html:
> >=20
> > Since the sky2 driver continues to suck ass (which is a technical
> > description for "it hangs all the time under load, at least on my
> > hardware" :-) ), I've fixed the sk98lin driver to compile for
> > linux-2.6.23-rc1. Those who continue to have problems with sky2 can
> > still use 2.6.23-rc1, simply by doing the following:
> >...
> > Personally, I'd like to see sk98lin remain in the kernel proper until
> > sky2 goes at least 6 months without reported problems.  The fact that I
> > am not the only one still seeing issues is a clear indication that sky2
> > (even with the recent patches in 2.6.23-rc1) is not yet ready to replace
> > sk98lin.
> >...
>=20
> This sounds good in theory.
>=20
> The practical problem with this approach is that there are always many=20
> people who use the old driver when the new driver doesn't work for them=
=20
> instead of reporting their problems with the new driver.
>=20
> For these people a new driver will often suck when the old driver gets=20
> removed, but after the removal of the old driver they are finally forced=
=20
> to report their bugs resulting in a better new driver for everyone.
>=20
> The sky2 driver is since nearly 2 years in the kernel and Stephen is=20
> usually quite good at handling bugs.

The driver still (2.6.20/sky2 1.13) hangs for me (more rarely than in
the past), and cycling the module generally fixes the issues.  I have
supplied all the information that Stephen has asked for, but still no
resolution.  I am not complaining about the lack of a fix, but don't
assume that all it takes to get sky2 working is adequate bug reports.  I
have been and remain willing to test and assist debug, but after several
dropped threads, I feel like the desire or ability to fix this issue
isn't there (and remote debug of an intermittent hardware issue IS
hard), and I didn't want to be a nuisance to someone that has no
obligation to me to address the issue in the first place.

Stability has improved, it's just not there yet.

I'll switch to 1.16 soon, and respond to Stephen's request on netdev for
current issues.
--=20
Rob

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGrVSKnvKppSZW8osRAigyAJ9h6WaEiV91tRq79k6skfNyO4bnOgCdGGHf
kTRgS0Dy6Wwhui8YLmDubAM=
=hXq9
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
