Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXDMIJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXDMIJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXDMIJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:09:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58894 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXDMIJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:09:39 -0400
Date: Fri, 13 Apr 2007 18:09:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
Message-Id: <20070413180942.b7cf0665.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_Apr_2007_18_09_42_+1000__f4Eyy77q9_GLQjs"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Apr_2007_18_09_42_+1000__f4Eyy77q9_GLQjs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Thu, 12 Apr 2007 20:33:16 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> just something i threw together, not in final form, but it represents
> tossing the legacy PM stuff.  at the moment, the menuconfig entry for
> PM_LEGACY lists it as "DEPRECATED", while the help screen calls it
> "obsolete."  that's a good sign that it's getting close to the time
> for it to go, and the removal is fairly straightforward, but there's
> no mention of its removal in the feature removal schedule file.

One thing that comes to mind is that you will need some way to make sure
that only one of ACPI and APM get initialized ...

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_Apr_2007_18_09_42_+1000__f4Eyy77q9_GLQjs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGHzrMFdBgD/zoJvwRAjSkAJ0dazeXRpeBxl32d3vH8ggPrzMD6wCeLaAx
WaFahF9Pg3xs39QfDOkT4SI=
=wDWz
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Apr_2007_18_09_42_+1000__f4Eyy77q9_GLQjs--
