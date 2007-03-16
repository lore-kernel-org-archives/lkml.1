Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXCPCf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXCPCf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 22:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXCPCf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 22:35:58 -0400
Received: from xenotime.net ([66.160.160.81]:59404 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751234AbXCPCf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 22:35:57 -0400
Date: Thu, 15 Mar 2007 18:34:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@infradead.org
Subject: Re: CONFIG_REORDER Kconfig help strange sentence.
Message-Id: <20070315183421.5b1cf51b.rdunlap@xenotime.net>
In-Reply-To: <1173767855.10618.46.camel@localhost.localdomain>
References: <1173741484.10618.25.camel@localhost.localdomain>
	<20070312235605.GA14444@muc.de>
	<1173767855.10618.46.camel@localhost.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007 17:37:35 +1100 Rusty Russell wrote:

> On Tue, 2007-03-13 at 00:56 +0100, Andi Kleen wrote:
> > On Tue, Mar 13, 2007 at 10:18:03AM +1100, Rusty Russell wrote:
> > > OK, this confused me:
> > > 
> > >         Function reordering (REORDER) [N/y/?] (NEW) ?
> > >         
> > >         This option enables the toolchain to reorder functions for a more 
> > >         optimal TLB usage. If you have pretty much any version of binutils, 
> > >         this can increase your kernel build time by roughly one minute.
> > >         
> > > "If you have pretty much any version of binutils"?  Huh?
> > > 
> > > You mean "This will slow your kernel build by about a minute"?
> > 
> > Yes. Lots of sections seem to trigger some quadratic behaviour in ld.
> > 
> > It might be fixed in some unreleased CVS version though (not 100% sure) 
> > 
> > -Andi
> 
> OK, well here is a patch for the moment.
> 
> ==
> Clarify CONFIG_REORDER explanation
> 
> if (1 && X) => if (X).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r de5618b5e562 arch/x86_64/Kconfig
> --- a/arch/x86_64/Kconfig	Tue Mar 13 11:41:55 2007 +1100
> +++ b/arch/x86_64/Kconfig	Tue Mar 13 17:27:05 2007 +1100
> @@ -632,8 +632,8 @@ config REORDER
>  	default n
>  	help
>           This option enables the toolchain to reorder functions for a more 
> -         optimal TLB usage. If you have pretty much any version of binutils, 
> -	 this can increase your kernel build time by roughly one minute.
> +         optimal TLB usage.  This will slow your kernel build by
> +	 roughly one minute.

Please consistently use <tab><space><space> for help text.
Yes, it was already mucked up.

>  config K8_NB
>  	def_bool y



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
