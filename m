Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYCNCpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYCNCpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYCNCpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:45:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50000 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbYCNCpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:45:45 -0400
Date: Fri, 14 Mar 2008 13:44:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for March 13
Message-Id: <20080314134404.5814f515.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0803131125010.9727@vixen.sonytel.be>
References: <20080313173506.2613be02.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0803131125010.9727@vixen.sonytel.be>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Mar_2008_13_44_04_+1100_2WqBuuFLbsZxtpaj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Mar_2008_13_44_04_+1100_2WqBuuFLbsZxtpaj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Thu, 13 Mar 2008 11:31:39 +0100 (CET) Geert Uytterhoeven <geert@linux-m6=
8k.org> wrote:
>
> I noticed you added `m68k-allnoconfig', which fails because of the follow=
ing

This was an experiment.  I disabled it again.

> reasons:
>   - There's no single CPU type enabled, hence we get:
>=20
> 	#define FPSTATESIZE error no_cpu_type_configured
>=20
>   - There's no single platform type enabled, hence we get no definition of
>     NR_IRQS:
>=20
> 	#error unknown nr of irqs
>=20
> Well yes, these are all `features' of allnoconfig :-)
> Or should we make sure you cannot build invalid configs like this?

I think that for architectures that do allow allnoconfig to build, they
have a fallback for these situations.  allnoconfig is a good quick way to
see if the core code builds ok for an architecture.

So maybe you could choose (even at random) defaults for the above two
things rather than erroring.  That would also help with randconfig builds.

If you make it work, let me know and I will reenable the build.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Mar_2008_13_44_04_+1100_2WqBuuFLbsZxtpaj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH2eZ9TgG2atn1QN8RAm6PAJ0aXywZhrmlhvWstRwMItFrjs3WGQCfeejI
petqOZi9acHWyekSA/5zeOg=
=oAWq
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Mar_2008_13_44_04_+1100_2WqBuuFLbsZxtpaj--
