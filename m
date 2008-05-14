Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYENMMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYENMMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbYENMMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:12:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60753 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbYENMMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:12:45 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: maximilian attems <max@stro.at>
Subject: Re: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace
Date: Wed, 14 May 2008 08:12:42 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, debian-kernel@lists.debian.org
References: <200805100836.48046.vapier@gentoo.org> <20080514110531.GA11775@stro.at> <20080514112950.GD27599@baikonur.stro.at>
In-Reply-To: <20080514112950.GD27599@baikonur.stro.at>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1321790.JrLYnzBmZC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805140812.44230.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1321790.JrLYnzBmZC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 14 May 2008, maximilian attems wrote:
> On Wed, May 14, 2008 at 01:05:31PM +0200, maximilian attems wrote:
> > could we please get an ack or nack on that patch.
> > checked linux-next and it doesn't appear there.
> > without it currently perl 5.10 doesn't build on alpha:
> > perl.c: In function 'perl_construct':
> > perl.c:388: error: 'CONFIG_HZ' undeclared (first use in this function)
> > ->
> > http://buildd.debian.org/fetch.cgi?pkg=3Dperl;ver=3D5.10.0-10;arch=3Dal=
pha;stam
> >p=3D1210252894
>
> hmm it seems more userspace expects CONFIG_HZ, so it's not only a perl
> build breakage..

anything using CONFIG_HZ is absolutely broken.  go fix the package.

anything using HZ should be converted to sysconf(), but i'm not about to go=
 on=20
that crusade to fix things up
=2Dmike

--nextPart1321790.JrLYnzBmZC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUASCrXPEFjO5/oN/WBAQKMkA/+NrBI955Q6UOCgP+ojAQsPuUcthDm9FlQ
f3Q84OlGsHnA7sujRUJxNMenYfNtKfDvDv80zhQg1jTJ1VRN2J+u/UbGSngxtMUW
4OWDQE6vpat5gs8r/a0dnNtl7l+zx61RNNRiEQbhyknX46Bci1zqLkbzxyjqyTwT
UMXlcg2dys9cpaResC6uF7eTYibvSiXLvkKJENPLKTr2e5nLnOBUQtPbrkMMcInw
VCqHZYXPVWI5/rs3x1uaYEYbsnovrJ0qe1jYkS5TbjV9UP/HyEXZuGADuKkyoYeW
p/6aJ3aDhDQodC5FGEeIKjKHN2HpEwu8Zw3x5jHqAG2xzcFdqWwfWaap5wCK7oL/
TY0WYNxPRHOshJG3eIL5pKh4iNx2DjgctaSlmLW51aq0JCT1FdspUR1j4mUjUpUO
F99uZuVE1Q+8ql+KsjY4d+eAc/9UCXDn4he3O1s5fns9dJzqCwTySQtsXJGnISiu
5SQC2pVLyXPVoKEZ9kIQ6C8TfN9eeL2aBZIy2KGgjtwjMeAv7/rWQP4RhOW9zy/r
njGnpUHSlhKywSdD/gsUeK2g7MSMO8ejWR3+RWVw8x2EF9twF8vbyJBtbzmThgwM
4VMcr/0pYBs/TkaKaTbpZ69MlwJ0Dd9HZ63hlFc5rd9glwEMXaVEcJfdbPz4AhRs
LcmOGU/FyPE=
=yGE7
-----END PGP SIGNATURE-----

--nextPart1321790.JrLYnzBmZC--
