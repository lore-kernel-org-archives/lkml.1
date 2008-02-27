Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYB0Guw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYB0Guw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 01:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYB0Gum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 01:50:42 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36923 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYB0Gul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 01:50:41 -0500
Date: Wed, 27 Feb 2008 08:49:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080227064934.GC10603@cs181133002.pp.htv.fi>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225190241.GA23161@uranus.ravnborg.org> <20080226094451.GL9857@elte.hu> <20080226201442.GB32685@uranus.ravnborg.org> <20080226203053.GB14350@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080226203053.GB14350@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 09:30:53PM +0100, Ingo Molnar wrote:
>...
> what would be really useful is an automatic Kconfig tree analysis, with 
> the printing out of too deep dependencies perhaps? Which might result in 
> the breaking down of too deep dependencies - to increase the coverage of 
> randconfig testing. Sometimes the number of "depends on" conditions are 
> mind-blowing.

Sounds like the academic masturbation of trying to find an optimal 
solution to a non-existing problem instead of fixing real issues.

The fact that most testers have a PC plus Toralfs randconfigs has
already catched virtually all compile issues visible on a PC in the 
past during -rc.

If you want to attack real problems then write a script that sends the 
names of all people who signed-off patches touching include/linux/ or 
include/asm-generic/ without having tested the compilation of at least 
the defconfig on all architectures to George W. Bush together with the 
information that these people possess at least as many weapons of mass 
destruction as Saddam Hussein in 2003...

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

