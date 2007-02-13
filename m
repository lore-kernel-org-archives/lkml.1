Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbXBMXR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbXBMXR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXBMXR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:17:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46061 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbXBMXRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:17:25 -0500
Date: Wed, 14 Feb 2007 10:17:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [patch] (2nd try)  add epoll compat code to kernel/compat.c ...
Message-Id: <20070214101750.587d42db.sfr@canb.auug.org.au>
In-Reply-To: <1171377785.3382.5.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0702111615340.24568@alien.or.mcafeemobile.com>
	<20070213153525.c1440cff.sfr@canb.auug.org.au>
	<1171377785.3382.5.camel@mulgrave.il.steeleye.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Feb_2007_10_17_50_+1100_EGw4dzWrm8xspTG9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Feb_2007_10_17_50_+1100_EGw4dzWrm8xspTG9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 13 Feb 2007 08:43:05 -0600 James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> Not for parisc at the instruction level.  In narrow mode (32 bit mode),
> a u64 load has to be done by two 32 bit loads which gives it a 4 byte
> alignment requirement.  In wide mode (64 bit mode) the 64 bit load
> instruction explicitly requires 8 byte alignment, so our u64 alignment
> requirements are different.  However, this is from the machine code
> point of view.  I can't say that gcc doesn't enforce an artificial 8
> byte alignment of u64 in narrow mode, so I'll defer to the gcc experts
> on that one.

Of course, gcc enforced alignment is all we really care about.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Feb_2007_10_17_50_+1100_EGw4dzWrm8xspTG9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF0kcjFdBgD/zoJvwRAlOxAJ9Zp2wLv3Krwmp0tdLKLYSazx6LpQCgnhDE
ieYwVd59342n48KEwF1FvW4=
=eb6x
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Feb_2007_10_17_50_+1100_EGw4dzWrm8xspTG9--
