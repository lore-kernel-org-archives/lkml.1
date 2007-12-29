Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbXL2Cb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbXL2Cb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXL2Cbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:31:50 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49304 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbXL2Cbt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:31:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <ak@suse.de>
Cc: Russell Leidich <rml@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
In-Reply-To: Your message of "Sat, 29 Dec 2007 03:11:51 +0100."
             <200712290311.51176.ak@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20071217185453.C4597CC562@localhost> <20071227233419.d1adf3f3.akpm@linux-foundation.org> <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com>
            <200712290311.51176.ak@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198895417_2814P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Dec 2007 21:30:17 -0500
Message-ID: <26145.1198895417@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198895417_2814P
Content-Type: text/plain; charset=us-ascii

On Sat, 29 Dec 2007 03:11:51 +0100, Andi Kleen said:
> On Friday 28 December 2007 21:40:28 Russell Leidich wrote:

> +		printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
> +			"functional.\n", cpu);
> 
> Why is that KERN_CRIT? Does not seem that critical to me.

If you think you're running on a chipset that *should* support thermal
monitoring, and it isn't there in a usable state, that seems pretty critical
to me.  If that didn't work, you probably can't trust the "oh, the chip will
thermal-limit itself if it gets to 100C or whatever" either.

Of course, I'm just speaking as somebody who quite recently had a system do a
thermal throttle when it hit 85C due to a cooling system failure.  I'm pretty
sure that if thermal monitoring wasn't functional, it wouldn't have throttled
either (after all, how can you throttle when you hit a given temp when you
don't have a working way to tell what the temp even is?), and I'd be looking at
extensive hardware damage...


--==_Exmh_1198895417_2814P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHdbE5cC3lWbTT17ARAsOhAJ9FGiDmuGRg9eTHLWTlWUXzMb1QFACgqb9f
1UGfTooeDJkd98VcB66AmsU=
=bsA1
-----END PGP SIGNATURE-----

--==_Exmh_1198895417_2814P--
