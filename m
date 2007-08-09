Return-Path: <linux-kernel-owner+w=401wt.eu-S937786AbXHIFbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937786AbXHIFbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXHIFbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:31:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50786 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbXHIFbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:31:43 -0400
Date: Thu, 9 Aug 2007 15:31:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 4/5 -v2] Added generic lg.h in the include/linux
 directory
Message-Id: <20070809153133.d5dff7b6.sfr@canb.auug.org.au>
In-Reply-To: <20070809044125.459178259@goodmis.org>
References: <20070809043626.830486783@goodmis.org>
	<20070809044125.459178259@goodmis.org>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Aug_2007_15_31_33_+1000_cLTAAr6tbZXREfb."
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Aug_2007_15_31_33_+1000_cLTAAr6tbZXREfb.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

I am just being pedantic here (and I should have beaten up on Rusty
before now ...  :-)

On Thu, 09 Aug 2007 00:36:30 -0400 Steven Rostedt <rostedt@goodmis.org>
wrote:
>
> --- a/include/asm-i386/lg.h
> +++ b/include/asm-i386/lg.h
> @@ -1,5 +1,5 @@
> -#ifndef _LGUEST_H
> -#define _LGUEST_H
> +#ifndef _I386_LGUEST_H
> +#define _I386_LGUEST_H

Maybe _ASM_LG_H or _I386_LG_H ? And there is a comment on the #endif at
the end of the file that should match.

> +++ b/include/linux/lg.h
> @@ -0,0 +1,30 @@
> +#ifndef _LINUX_LGUEST_H
> +#define _LINUX_LGUEST_H

Maybe _LINUX_LG_H ?

Also (this is for Rusty) include/linux/lguest.h is protected by
_ASM_LGUEST_H ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Aug_2007_15_31_33_+1000_cLTAAr6tbZXREfb.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGuqa6TgG2atn1QN8RAmJPAJ4gcct+revTVWqW6yTxblm3Jt4MawCfRMih
BHtkczFmBmKURUW89aQUUHM=
=dKUJ
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Aug_2007_15_31_33_+1000_cLTAAr6tbZXREfb.--
