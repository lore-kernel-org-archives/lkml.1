Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbZANPzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbZANPzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZANPza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:55:30 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:51449 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbZANPz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:55:29 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ZNLLVZ9xIWrKqL3mIGLkz
Date: Wed, 14 Jan 2009 17:55:28 +0200
From: Tony Lindgren <tony@atomide.com>
To: david.hagood@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Git as of 13-Jan-2009 build fail on OMAP3
Message-ID: <20090114155525.GQ29324@atomide.com>
References: <200901121356.46236.elendil@planet.nl> <20090113123056.GA2464@deprecation.cyrius.com> <1abb5d601cc91bdaa406e206cb92094f.squirrel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1abb5d601cc91bdaa406e206cb92094f.squirrel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* david.hagood@gmail.com <david.hagood@gmail.com> [090114 12:18]:
> I am attempting to build the stock kernel as pulled from the kernel GIT
> server for an OMAP3 platform, and am getting errors.
> 
> The version I am working with (as displayed by "git show") is "commit
> e0b325d310a6b11f1538413fd557d2eb98f2fae5".

I posted some omap build fixes to linux-arm-kernel few days ago.
You can cherry pick the build fixes from:

http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=shortlog;h=omap-fixes

Hopefully these will get to mainline within few days.

Regards,

Tony



> 
> The error is:
> 
> 
>   CC      arch/arm/mach-omap2/board-omap3beagle.o
> arch/arm/mach-omap2/board-omap3beagle.c: In function ‘beagle_twl_gpio_setup’:
> arch/arm/mach-omap2/board-omap3beagle.c:132: error: ‘TWL4030_GPIO_MAX’
> undeclared (first use in this function)
> arch/arm/mach-omap2/board-omap3beagle.c:132: error: (Each undeclared
> identifier is reported only once
> arch/arm/mach-omap2/board-omap3beagle.c:132: error: for each function it
> appears in.)
> arch/arm/mach-omap2/board-omap3beagle.c: At top level:
> arch/arm/mach-omap2/board-omap3beagle.c:141: error: variable
> ‘beagle_gpio_data’ has initializer but incomplete type
> arch/arm/mach-omap2/board-omap3beagle.c:142: error: unknown field
> ‘gpio_base’ specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:142: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:142: warning: (near initialization
> for ‘beagle_gpio_data’)
> arch/arm/mach-omap2/board-omap3beagle.c:143: error: unknown field
> ‘irq_base’ specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:143: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:143: warning: (near initialization
> for ‘beagle_gpio_data’)
> arch/arm/mach-omap2/board-omap3beagle.c:144: error: unknown field
> ‘irq_end’ specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:144: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:144: warning: (near initialization
> for ‘beagle_gpio_data’)
> arch/arm/mach-omap2/board-omap3beagle.c:145: error: unknown field
> ‘use_leds’ specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:145: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:145: warning: (near initialization
> for ‘beagle_gpio_data’)
> arch/arm/mach-omap2/board-omap3beagle.c:146: error: unknown field
> ‘pullups’ specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:146: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:146: warning: (near initialization
> for ‘beagle_gpio_data’)
> arch/arm/mach-omap2/board-omap3beagle.c:147: error: unknown field
> ‘pulldowns’ specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:148: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:148: warning: (near initialization
> for ‘beagle_gpio_data’)
> arch/arm/mach-omap2/board-omap3beagle.c:149: error: unknown field ‘setup’
> specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:149: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:149: warning: (near initialization
> for ‘beagle_gpio_data’)
> arch/arm/mach-omap2/board-omap3beagle.c:152: error: variable
> ‘beagle_twldata’ has initializer but incomplete type
> arch/arm/mach-omap2/board-omap3beagle.c:153: error: unknown field
> ‘irq_base’ specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:153: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:153: warning: (near initialization
> for ‘beagle_twldata’)
> arch/arm/mach-omap2/board-omap3beagle.c:154: error: unknown field
> ‘irq_end’ specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:154: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:154: warning: (near initialization
> for ‘beagle_twldata’)
> arch/arm/mach-omap2/board-omap3beagle.c:157: error: unknown field ‘gpio’
> specified in initializer
> arch/arm/mach-omap2/board-omap3beagle.c:157: warning: excess elements in
> struct initializer
> arch/arm/mach-omap2/board-omap3beagle.c:157: warning: (near initialization
> for ‘beagle_twldata’)
> arch/arm/mach-omap2/board-omap3beagle.c: In function ‘omap3_beagle_init’:
> arch/arm/mach-omap2/board-omap3beagle.c:308: error: ‘gpio’ undeclared
> (first use in this function)
> make[1]: *** [arch/arm/mach-omap2/board-omap3beagle.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2
> 
> I do have the TWL4030 enabled in the config.
> 
> Has anybody else tried this?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
