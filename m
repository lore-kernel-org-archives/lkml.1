Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZCJRc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZCJRc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZCJRcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:32:45 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:34945 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbZCJRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:32:44 -0400
Subject: Re: [Bug #12806] i915 broken STR
From: Eric Anholt <eric@anholt.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <200903101456.48444.rjw@sisk.pl>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
	 <200903072228.47358.rjw@sisk.pl> <1236651832.10190.20.camel@gaiman>
	 <200903101456.48444.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zyLXdcwe2xV8U98OmqfH"
Date: Tue, 10 Mar 2009 10:32:28 -0700
Message-Id: <1236706348.10190.65.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zyLXdcwe2xV8U98OmqfH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 14:56 +0100, Rafael J. Wysocki wrote:
> On Tuesday 10 March 2009, Eric Anholt wrote:
> > On Sat, 2009-03-07 at 22:28 +0100, Rafael J. Wysocki wrote:
> > > On Saturday 07 March 2009, Harvey Harrison wrote:
> > > > On Tue, 2009-03-03 at 20:25 +0100, Rafael J. Wysocki wrote:
> > > > > This message has been generated automatically as a part of a repo=
rt
> > > > > of recent regressions.
> > > > >=20
> > > > > The following bug entry is on the current list of known regressio=
ns
> > > > > from 2.6.28.  Please verify if it still should be listed and let =
me know
> > > > > (either way).
> > > > >=20
> > > > >=20
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D12806
> > > > > Subject		: i915 broken STR
> > > > > Submitter	: Harvey Harrison <harvey.harrison@gmail.com>
> > > > > Date		: 2009-02-28 4:20 (4 days old)
> > > > > First-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/tor=
valds/linux-2.6.git;a=3Dcommit;h=3D5669fcacc58bf3a7386057addffd280d75380858
> > > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D1235794878010=
64&w=3D4
> > > > >=20
> > > > >=20
> > > >=20
> > > > This looks to have been a case of old-userspace..upgrading to
> > > > xorg-intel-video 2.6.1 (ubuntu Jaunty Alpha5) fixes STR here.
> > >=20
> > > Well, thanks, but I'm not really sure if this is a good news.
> > >=20
> > > Jesse, Eric, does it mean we now break resume on anything earlier tha=
n 2.6.1
> > > on the Harvey's hardware?
> >=20
> > There's not much information (dmesg, Xorg.0.log) with this bug -- I'm
> > guessing he's using KMS, given that that commit was where the problems
> > started.  If so, yes, you really do need good userland for KMS to work.
>=20
> BTW, Is suspend generally supposed to work with KMS and the 2.6.1 (or lat=
er) X
> driver?

I pulled a giant pile of KMS bugfixes into 2.6.2, so I'm not sure about
2.6.1.

We've still got some work to do with making our suspend/resume path
really complete for KMS.  We're missing some register setup that UMS
does, so behavior can be a bit random.  The current plan is to switch to
using the KMS modeset paths for resume, so we hopefully have reliable
(or at least consistent) mode setting behavior, and then fill those
remaining register writes in around it.  Basically, a separate
suspend/resume path for KMS, when we have full control of the device.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-zyLXdcwe2xV8U98OmqfH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm2pCwACgkQHUdvYGzw6vcHuwCfQuIEjQk/sJCwLtvkL5K5SBMp
/30An3IpC4q01nOh0Vq4C4wasjNq9Kv5
=Nk09
-----END PGP SIGNATURE-----

--=-zyLXdcwe2xV8U98OmqfH--
