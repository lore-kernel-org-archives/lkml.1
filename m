Return-Path: <linux-kernel-owner+w=401wt.eu-S934168AbXEOLsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbXEOLsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbXEOLsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:48:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53667 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbXEOLsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:48:07 -0400
Date: Tue, 15 May 2007 21:47:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, hch <hch@infradead.org>
Subject: Re: [PATCH 1/6] lguest: host code tidyups
Message-Id: <20070515214756.b8020d4e.sfr@canb.auug.org.au>
In-Reply-To: <20070515214235.b0625699.sfr@canb.auug.org.au>
References: <1179191827.10836.24.camel@localhost.localdomain>
	<20070515214235.b0625699.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_May_2007_21_47_56_+1000_S8/L=E9NysAaZpyz"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_May_2007_21_47_56_+1000_S8/L=E9NysAaZpyz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 15 May 2007 21:42:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> On Tue, 15 May 2007 11:17:07 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > @@ -420,7 +421,7 @@ static int __init init(void)
> >  	lock_cpu_hotplug();
> >  	if (cpu_has_pge) { /* We have a broader idea of "global". */
> >  		cpu_had_pge = 1;
> > -		on_each_cpu(adjust_pge, 0, 0, 1);
> > +		on_each_cpu(adjust_pge, (void *)0, 0, 1);
>
> Sorry?  What ever happened to a simple NULL?

Oh, I guess that is an explicit (numeric) 0 (of some type) caste to
"void *" because of the prototype - rather than not passing anything?

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_May_2007_21_47_56_+1000_S8/L=E9NysAaZpyz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGSZ31FdBgD/zoJvwRAvVGAJ9YNLTHaPYgOHhHgwYdjQ52RSdalwCfbCTW
9UHYMTprheMvivmqzblpXT4=
=M6/4
-----END PGP SIGNATURE-----

--Signature=_Tue__15_May_2007_21_47_56_+1000_S8/L=E9NysAaZpyz--
