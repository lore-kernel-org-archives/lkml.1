Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbXCNSCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbXCNSCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXCNSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:02:12 -0400
Received: from hydra.gt.owl.de ([195.71.99.218]:48632 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbXCNSCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:02:11 -0400
Date: Wed, 14 Mar 2007 19:02:09 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [6/6] 2.6.21-rc3: known regressions
Message-ID: <20070314180209.GA15640@paradigm.rfc822.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313125025.GW18731@stusta.de> <1173818777.13341.128.camel@localhost.localdomain> <20070314114417.GB18731@stusta.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20070314114417.GB18731@stusta.de>
Organization: rfc822 - pure communication
X-SpiderMe: mh-200703141900@listme.rfc822.org
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 14, 2007 at 12:44:17PM +0100, Adrian Bunk wrote:
> > > Due to the huge amount of recipients, please trim the Cc when answeri=
ng.
> > > Subject    : Clocksource tsc unstable (delta =3D -154983451 ns)
> > > References : http://lkml.org/lkml/2007/3/9/271
> > > Submitter  : Jiri Slaby <jirislaby@gmail.com>
> > > Status     : unknown
> >=20
> > That's not a regression. That's an informal message, when the TSC
> > watchdog detects that the TSC is unreliable.=20
>=20
> Looking at [1], there's also be a probably related "doesn't boot"=20
> problem.
> My first guess would be commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
> "clocksource init adjustments (fix bug #7426)".
>=20
> Jiri, is the message also present with 2.6.21-rc2 (at a different place=
=20
> of the dmesg) for you?

With the current git of today the halt on boot is gone. I am running=20
it now ...

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF+DigUaz2rXW+gJcRAsQxAKCWoP8Z76xZuYWK/XtQT07n6qiLegCeKln4
tRzvEVq3Vy0JwnPXTaTaplM=
=IRsL
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
