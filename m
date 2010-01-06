Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372Ab0AFW2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab0AFW2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963Ab0AFW2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:28:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab0AFW2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:28:19 -0500
Date: Wed, 6 Jan 2010 16:27:59 -0600
From: Clark Williams <williams@redhat.com>
To: Carsten Emde <Carsten.Emde@osadl.org>
Cc: John Kacur <jkacur@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
Message-ID: <20100106162759.1d4d5b57@torg>
In-Reply-To: <4B450D91.7060403@osadl.org>
References: <20100106130400.7f30ae55@torg>
	<520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>
	<4B4502FD.1000404@osadl.org>
	<20100106160434.77efc790@torg>
	<4B450D91.7060403@osadl.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p06JtRyPZk1fIbacFU.KhNT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p06JtRyPZk1fIbacFU.KhNT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Jan 2010 23:24:17 +0100
Carsten Emde <Carsten.Emde@osadl.org> wrote:

> Clark,
>=20
> >> [..]
> >> Here is my proposal:
> >> Do not change the meaning of existing options. Introduce a new option
> >> that is mutual exclusive with the -a, the -t and the -d option. This n=
ew
> >> option does the same as -a and -t and -d0 and sets the same priority to
> >> all threads. How about that?
> > Ugh, I truly *hate* adding options. Do you know that cyclictest is
> > halfway to having as many options as 'ls'?
> Well, yes, we have the choice between two bad things, breaking
> compatibility or adding another option. I prefer the latter.

Ok, I yield()  :)

> > [..]
> > How about if we create the -S/--smp option that takes no arguments and
> > causes -a, -t and -d to be ignored (with a warning). This option would
> > create one thread per cpu, each thread pinned to it's corresponding
> > cpu, all with the same sampling interval (i.e. -d0) and the same
> > priority?
> Sounds good to me.
>=20
> May I ask you to also include the -n option which is almost always
> needed? This would then give:
>=20
> -S      --smp              Standard SMP testing (equals -a -t -n -d0),
>                            same priority on all threads.
>=20
> 	Carsten.

Yeah, you read my mind. How about -m (mlockall) as well?

Clark

--Sig_/p06JtRyPZk1fIbacFU.KhNT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAktFDnkACgkQHyuj/+TTEp2J1wCgnOaFBCa3WNkQ2WX5dW/+fPpJ
zLEAn0oqG7XhTxcNRirBgdaiJj5zJTrS
=+rFn
-----END PGP SIGNATURE-----

--Sig_/p06JtRyPZk1fIbacFU.KhNT--
