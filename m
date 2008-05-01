Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYEABSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYEABSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYEABS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:18:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52904 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYEABSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:18:25 -0400
Date: Thu, 1 May 2008 11:18:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, htejun@gmail.com,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Emilian.Medve@Freescale.com, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2] [POWERPC] devres: Add devm_ioremap_flags()
Message-Id: <20080501111817.e0d19258.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0804301106010.22992@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0804301106010.22992@blarg.am.freescale.net>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_May_2008_11_18_17_+1000_I.KODudsyXwzfRnh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_May_2008_11_18_17_+1000_I.KODudsyXwzfRnh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Apr 2008 11:08:51 -0500 (CDT) Kumar Gala <galak@kernel.crashing.=
org> wrote:
>
> +++ b/arch/powerpc/lib/devres.c
> @@ -0,0 +1,33 @@
> +#include <linux/device.h>	/* devres_*(), devm_ioremap_release() */
> +#include <linux/io.h>		/* ioremap_flags() */
> +#include <linux/module.h>	/* EXPORT_SYMBOL() */

This file needs a copyright notice and license ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_May_2008_11_18_17_+1000_I.KODudsyXwzfRnh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIGRpdTgG2atn1QN8RAljoAJsEEhyCmz92exTYDTqpFy4aSQG69gCfWHnS
kCHJIEd0ARTyFnzKIcTMV2A=
=MxSH
-----END PGP SIGNATURE-----

--Signature=_Thu__1_May_2008_11_18_17_+1000_I.KODudsyXwzfRnh--
