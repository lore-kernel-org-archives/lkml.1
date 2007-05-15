Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbXEOLmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbXEOLmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbXEOLmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:42:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53140 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbXEOLmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:42:45 -0400
Date: Tue, 15 May 2007 21:42:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, hch <hch@infradead.org>
Subject: Re: [PATCH 1/6] lguest: host code tidyups
Message-Id: <20070515214235.b0625699.sfr@canb.auug.org.au>
In-Reply-To: <1179191827.10836.24.camel@localhost.localdomain>
References: <1179191827.10836.24.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_May_2007_21_42_35_+1000_vPSON/bHz0.hQQG_"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_May_2007_21_42_35_+1000_vPSON/bHz0.hQQG_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 15 May 2007 11:17:07 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> @@ -420,7 +421,7 @@ static int __init init(void)
>  	lock_cpu_hotplug();
>  	if (cpu_has_pge) { /* We have a broader idea of "global". */
>  		cpu_had_pge = 1;
> -		on_each_cpu(adjust_pge, 0, 0, 1);
> +		on_each_cpu(adjust_pge, (void *)0, 0, 1);

Sorry?  What ever happened to a simple NULL?

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_May_2007_21_42_35_+1000_vPSON/bHz0.hQQG_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGSZyyFdBgD/zoJvwRAjZ6AJ9gk5CB7+LxR0nzjv9+ayJ8VXjSJwCfYrft
XaX8ZE5zfW6q98PmPJTJJdU=
=hwQS
-----END PGP SIGNATURE-----

--Signature=_Tue__15_May_2007_21_42_35_+1000_vPSON/bHz0.hQQG_--
