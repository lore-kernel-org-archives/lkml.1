Return-Path: <linux-kernel-owner+w=401wt.eu-S1763489AbYGaAXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763489AbYGaAXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761551AbYGaAWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:22:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32797 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbYGaAWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:22:03 -0400
Date: Thu, 31 Jul 2008 10:21:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: eranian@gmail.com
Cc: "stephane eranian" <eranian@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/19] perfmon2 minimal v3: introduction
Message-Id: <20080731102154.b06476dd.sfr@canb.auug.org.au>
In-Reply-To: <7c86c4470807301659t232a8dabw5272988d164898e@mail.gmail.com>
References: <4868dbf6.0af5660a.1972.52f4@mx.google.com>
	<20080729014730.76b879a4.sfr@canb.auug.org.au>
	<7c86c4470807282320o2d072c7dp7a327f133d5969c5@mail.gmail.com>
	<7c86c4470807301659t232a8dabw5272988d164898e@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__31_Jul_2008_10_21_54_+1000_UztBWDODjaHoed7q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Jul_2008_10_21_54_+1000_UztBWDODjaHoed7q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephane,

On Wed, 30 Jul 2008 16:59:34 -0700 "stephane eranian" <eranian@googlemail.c=
om> wrote:
>
> On Mon, Jul 28, 2008 at 11:20 PM, stephane eranian
> <eranian@googlemail.com> wrote:
> >>        quite a few of the macros (especially for the dummy (non
> >> CONFIG_PERFMON) versions of functions) should be "static inline"
> >> functions unless they absolutely must be macros.  Andrew Morton said it
> >> best - "write in C not C preprocessor".
> >>
> Do you also have a problem with the debug printk statements using macros?

Not really, they would be a pain to write as C code.

The advantage of using C code for the dummy versions of things is that we
still get type checking and we eliminate "unused variable" warnings for
parameters of the functions.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__31_Jul_2008_10_21_54_+1000_UztBWDODjaHoed7q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiRBaIACgkQjjKRsyhoI8yl2gCeP8cfpqGQJKFAHufrUCT61Goi
5wIAnj4e4twdmZ3zubxAW/QY98D+58VA
=ZnIv
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Jul_2008_10_21_54_+1000_UztBWDODjaHoed7q--
