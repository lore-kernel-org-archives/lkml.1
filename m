Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864Ab0AGOrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0AGOrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561Ab0AGOrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:47:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0AGOrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:47:12 -0500
Date: Thu, 7 Jan 2010 08:47:00 -0600
From: Clark Williams <williams@redhat.com>
To: Carsten Emde <Carsten.Emde@osadl.org>
Cc: John Kacur <jkacur@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
Message-ID: <20100107084700.0fa053a3@torg>
In-Reply-To: <4B458C08.8070209@osadl.org>
References: <20100106130400.7f30ae55@torg>
	<520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>
	<4B4502FD.1000404@osadl.org>
	<20100106160434.77efc790@torg>
	<4B450D91.7060403@osadl.org>
	<20100106162759.1d4d5b57@torg>
	<4B458C08.8070209@osadl.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZolRzvN_=TC5EzUMdLs3_.0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZolRzvN_=TC5EzUMdLs3_.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Jan 2010 08:23:52 +0100
Carsten Emde <Carsten.Emde@osadl.org> wrote:

> Clark,
>=20
> >> -S      --smp              Standard SMP testing (equals -a -t -n -d0),
> >>                            same priority on all threads.
> After having done some tests with a quickly hacked cyclictest version, I
> have found an issue with including -d0. Apparently, small numbers make
> life especially difficult for the scheduler; this is why we often used
> -d1. Specifying -d0 seems a special case where all threads are in sync.
> Maybe, we may miss some important latency constellations, if we do not
> let the tasks slightly interfere. In any case, I would like to be able
> to specify a distance _in addition_ to -S. This would create a scenario
> where
>=20
>   cyclictest -d1 -S
>=20
> results in a distance of 0, and
>=20
>   cyclictest -S -d1
>=20
> results in a distance of 1. Would this be acceptable?
>=20
> 	Carsten.

I don't have a problem not having -d in the -S option. I was looking at
the possibility of synchronous sampling as well so it's probably a good
idea to keep it separate.=20

The main things we want are implied -t, -a and -n.

Clark

--Sig_/ZolRzvN_=TC5EzUMdLs3_.0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAktF8+cACgkQHyuj/+TTEp3cygCfZeW9OJNGy2nikwbnVB3yOPel
nREAnivAlQKT+4lPpWVefDB+c4Kj5Haq
=kn+R
-----END PGP SIGNATURE-----

--Sig_/ZolRzvN_=TC5EzUMdLs3_.0--
