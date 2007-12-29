Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbXL2C5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbXL2C5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXL2C5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:57:47 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:32812 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbXL2C5q (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:57:46 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <ak@suse.de>
Cc: Russell Leidich <rml@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
In-Reply-To: Your message of "Sat, 29 Dec 2007 03:34:34 +0100."
             <200712290334.34609.ak@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20071217185453.C4597CC562@localhost> <200712290311.51176.ak@suse.de> <26145.1198895417@turing-police.cc.vt.edu>
            <200712290334.34609.ak@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198897033_2814P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Dec 2007 21:57:13 -0500
Message-ID: <27599.1198897033@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198897033_2814P
Content-Type: text/plain; charset=us-ascii

On Sat, 29 Dec 2007 03:34:34 +0100, Andi Kleen said:
> On Saturday 29 December 2007 03:30:17 Valdis.Kletnieks@vt.edu wrote:
> > On Sat, 29 Dec 2007 03:11:51 +0100, Andi Kleen said:
> > > On Friday 28 December 2007 21:40:28 Russell Leidich wrote:
> > 
> > > +		printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
> > > +			"functional.\n", cpu);
> > > 
> > > Why is that KERN_CRIT? Does not seem that critical to me.
> > 
> > If you think you're running on a chipset that *should* support thermal
> > monitoring, and it isn't there in a usable state, that seems pretty critical
> > to me.  If that didn't work, you probably can't trust the "oh, the chip will
> > thermal-limit itself if it gets to 100C or whatever" either.
>
> Thermal shutdown in emergency uses quite different mechanisms (e.g. it goes
> directly through pins to the motherboard); i don't think that code checks for
> that.

Right. My point is that if monitoring *should* be working, and it isn't, then
you don't have a lot of reason to be 100% confident that those pins are working
either.  Unless there's two totally separate temperature sensors - otherwise,
if that sensor goes out, thermal monitoring and the emergency stuff *both*
break.

Of course, if somebody wise on the actual hardware design can definitively
state that even if the thermal sensor the monitoring uses dies, the chipset
will still thermal-throttle correctly, then I'd agree that the message could
go down to KERN_ERR or KERN_WARN.....


--==_Exmh_1198897033_2814P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHdbeJcC3lWbTT17ARAupmAJ0SZm8pb5U3CMIAUxMhuZdvpDIi9gCdGDdt
xIflqhzpZE5uoZLa/jEAlf4=
=moaM
-----END PGP SIGNATURE-----

--==_Exmh_1198897033_2814P--
