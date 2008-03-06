Return-Path: <linux-kernel-owner+w=401wt.eu-S934945AbYCFVH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945AbYCFVH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbYCFVHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:07:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbYCFVHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:07:09 -0500
Date: Thu, 6 Mar 2008 22:06:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Message-ID: <20080306210652.GA24929@elte.hu>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz> <200803052331.42193.ak@suse.de> <20080306111408.GM13391@elte.hu> <200803061230.38171.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803061230.38171.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> > but the first fundamental limit we'll hit on 64-bit is the 32-bit 
> > offset
> 
> 31bit to be pedantic.

yeah.

> [...]
>
> Newer gcc/binutils support the large code model so you could actually 
> try to generate binaries that big :-) e.g. some of the rtl-to-C 
> compilers seem to generate huge code so it might be actually useful.

The largest kernel image i've had so far was slightly above 40MB so at 
least in the kernel we are not there yet ;-)

Do you have any experience with how much of a size difference there is 
when binaries are built for big address mode? I'd expect something in 
the neighborhood of 5% for an image with a structure similar to the 
kernel's but maybe it's more.

> Also of course you can always split the executable into ~2GB shared 
> libraries.

... which brings back happy memories of DOS extenders ;-)

	Ingo
