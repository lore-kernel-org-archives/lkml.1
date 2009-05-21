Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbZEUFKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbZEUFKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZEUFJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:09:52 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53745 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZEUFJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:09:51 -0400
Subject: Re: [PATCH] include KERN_* constant in printk calls
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Chris Sanford <crsanford@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       peterz@infradead.org
In-Reply-To: <20090521024635.GA4030@chrisubuntu-laptop>
References: <20090518233121.GC3109@chrisubuntu-laptop>
	 <20090519090049.GB9388@elte.hu> <20090520043215.GA3077@chrisubuntu-laptop>
	 <20090520083719.GG6736@elte.hu>  <20090521024635.GA4030@chrisubuntu-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MfIMBwRLTGQ78GlccD77"
Date: Thu, 21 May 2009 15:09:52 +1000
Message-Id: <1242882592.4784.44.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MfIMBwRLTGQ78GlccD77
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-20 at 19:46 -0700, Chris Sanford wrote:
> Here is the updated patch for sched.c. It replaces all the printk calls w=
ith their
> corresponding pr_* call. The five KERN_DEBUG calls have been changed to
> pr_info.

Switching from KERN_DEBUG to KERN_INFO means the messages will now
appear for most people, whereas previously they didn't. I'm not sure
that's a great idea.

If you really want to convert them, then I think we need a macro for
KERN_DEBUG but not conditionally compiled like pr_debug.

I sent a patch for that once, but I don't think anyone liked it, and
I've lost it now :D

cheers

--=-MfIMBwRLTGQ78GlccD77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoU4iAACgkQdSjSd0sB4dLcGwCgv+kunIxTBw+wggS2he6Au+B/
Ix8An1Rtxj57bgtMm/R0WkABm9Kr2R1Q
=0sUu
-----END PGP SIGNATURE-----

--=-MfIMBwRLTGQ78GlccD77--

