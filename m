Return-Path: <linux-kernel-owner+w=401wt.eu-S2992995AbXCIGWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992995AbXCIGWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992999AbXCIGWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:22:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35886 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992995AbXCIGWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:22:53 -0500
Date: Fri, 9 Mar 2007 17:22:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-Id: <20070309172243.2fda15a6.sfr@canb.auug.org.au>
In-Reply-To: <1173419792.32234.131.camel@localhost.localdomain>
References: <1173419792.32234.131.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Mar_2007_17_22_43_+1100_7HbM69BQxdP6vnVZ"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2007_17_22_43_+1100_7HbM69BQxdP6vnVZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Fri, 09 Mar 2007 16:56:32 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> __builtin_types_compatible_p() has been around since gcc 2.95, and we
> don't use it anywhere.  This patch quietly fixes that.

After staring at this for about 2 minutes, how about a commit message like:

Make ARRAY_SIZE complain strangely if passed a pointer instead of an
array.

:-)
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Mar_2007_17_22_43_+1100_7HbM69BQxdP6vnVZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF8P08FdBgD/zoJvwRAuA/AKCCurpEpkWnmc3UKb+9TK2r5rkDFgCePOy/
gX5eLGv6lGFsonf5JKTGRC4=
=Yfh/
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2007_17_22_43_+1100_7HbM69BQxdP6vnVZ--
