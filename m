Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYFWCBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYFWCBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYFWCBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:01:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36503 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYFWCBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:01:03 -0400
Date: Mon, 23 Jun 2008 12:00:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 02/19] perfmon2 minimal v2:  base code
Message-Id: <20080623120053.25de0173.sfr@canb.auug.org.au>
In-Reply-To: <48583462.25014e0a.0982.6263@mx.google.com>
References: <48583462.25014e0a.0982.6263@mx.google.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_Jun_2008_12_00_53_+1000_F=4gpwUQXag2P8pQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Jun_2008_12_00_53_+1000_F=4gpwUQXag2P8pQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephane,

On Tue, 17 Jun 2008 15:02:10 -0700 (PDT) eranian@googlemail.com wrote:
>
> +++ o/perfmon/Makefile	2008-06-17 08:33:23.000000000 +0200
> @@ -0,0 +1,7 @@
> +#
> +# Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
> +# Contributed by Stephane Eranian <eranian@gmail.com>
> +#
> +obj-$(CONFIG_PERFMON) =3D perfmon_ctx.o \
> +			perfmon_file.o perfmon_attach.o 	\
> +			perfmon_res.o perfmon_init.o

> +++ o/Makefile	2008-06-17 08:34:19.000000000 +0200
> @@ -607,7 +607,7 @@
> =20
> =20
>  ifeq ($(KBUILD_EXTMOD),)
> -core-y		+=3D kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> +core-y		+=3D kernel/ mm/ fs/ ipc/ security/ crypto/ block/ perfmon/

Is there some reason that this is not

core-$(CONFIG_PERFMON)	+=3D perfmon/

and then you could just use "obj-y" in perfmon/Makefile

Or are there going to be things in perfmon/ that need building if
CONFIG_PERFMON is not set?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_Jun_2008_12_00_53_+1000_F=4gpwUQXag2P8pQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhfA9UACgkQTgG2atn1QN8K2ACghDZNXwWHvjbPaxo34aCpUn44
bC4An37anhlugSwKqwGfRzegtoYD7kHv
=LIPG
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jun_2008_12_00_53_+1000_F=4gpwUQXag2P8pQ--
