Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYBYLSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYBYLSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYBYLSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:18:32 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50231 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYBYLSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:18:31 -0500
Date: Mon, 25 Feb 2008 13:17:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225111733.GB32450@cs181133002.pp.htv.fi>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <200802251124.17561.florian.fainelli@telecomint.eu> <20080225105110.GA5648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080225105110.GA5648@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:51:10AM +0100, Ingo Molnar wrote:
> 
> * Florian Fainelli <florian.fainelli@telecomint.eu> wrote:
> 
> > > In fact for rdc321x that should be rather easy to do right now: 
> > > wdt.c could/should become a regular watchdog driver, and do we 
> > > really need those GPIO specials in include/asm-x86/mach-rdc321x/ ? I 
> > > believe it should be possible to boot CONFIG_X86_GENERICARCH on a 
> > > rdc321x. Am i missing any particular complication?
> > 
> > The GPIO calls will be moving later when I have finished the gpiolib 
> > integration for RDC just like what is currently done for ARM. You are 
> > right for the watchdog driver, I will move it right now.
> 
> ok, great! Btw., do you think you could achieve your board to boot fine 
> with CONFIG_X86_GENERICARCH=y and CONFIG_M486=y?

Booting it might fine, but CLOCK_TICK_RATE will be wrong...

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

