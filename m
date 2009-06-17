Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbZFQNIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbZFQNIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZFQNIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:08:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44020 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbZFQNII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:08:08 -0400
Date: Wed, 17 Jun 2009 23:08:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: arm build failures
Message-Id: <20090617230804.5e353ec9.sfr@canb.auug.org.au>
In-Reply-To: <tnx3a9ztg14.fsf@pc1117.cambridge.arm.com>
References: <20090617162612.703adfd9.sfr@canb.auug.org.au>
	<tnx3a9ztg14.fsf@pc1117.cambridge.arm.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Jun_2009_23_08_04_+1000_b+Q_nTnN3K=kJYz8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Jun_2009_23_08_04_+1000_b+Q_nTnN3K=kJYz8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

On Wed, 17 Jun 2009 09:34:31 +0100 Catalin Marinas <catalin.marinas@arm.com=
> wrote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Over the past few days, I have started getting some arm configs (at lea=
st
> > iop13xx_defconfig and integrator_defconfig, but some others) failing to
> > build getting this error:
> >
> >   SYSMAP  System.map
> >   SYSMAP  .tmp_System.map
> > Inconsistent kallsyms data
> > Try setting CONFIG_KALLSYMS_EXTRA_PASS
> >
> > Is this something you have seen?  Could it be my toolchain (I am
> > currently using gcc 4.4.0 and have not changed it recently)?
>=20
> I reported an error with kallsysms on ARM this Monday leading to
> inconsistent data:
>=20
> http://lkml.org/lkml/2009/6/15/233
>=20
> Could it be related?

Could be.  I have added the proposed fix patch to my fixes tree until
Linus or Sam gets around to including it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Jun_2009_23_08_04_+1000_b+Q_nTnN3K=kJYz8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko46rQACgkQjjKRsyhoI8w8LwCeIBr/FjDk4mzfF3hpImX1xBHy
uy4An1DUZnaqaJLPandxqsnHgw2iSb5T
=lKcr
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jun_2009_23_08_04_+1000_b+Q_nTnN3K=kJYz8--
