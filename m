Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab0CAVRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:17:40 -0500
Received: from ip-85-161-92-63.eurotel.cz ([85.161.92.63]:57918 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752153Ab0CAVRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:17:39 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 16:17:35 EST
Date: Mon, 1 Mar 2010 22:10:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] staging/dream: add missing include files/fix
 compilation
Message-ID: <20100301211057.GA3004@elf.ucw.cz>
References: <1263914079.1951.43.camel@m0nster>
 <20100131084421.GG2238@elf.ucw.cz>
 <20100131092829.GJ2238@elf.ucw.cz>
 <1264953492.2059.5.camel@m0nster>
 <20100225193027.GA7391@elf.ucw.cz>
 <1267126586.5439.56.camel@c-dwalke-linux.qualcomm.com>
 <20100225194125.GA7645@elf.ucw.cz>
 <1267127298.5439.62.camel@c-dwalke-linux.qualcomm.com>
 <20100226213107.GA29615@elf.ucw.cz>
 <1267469856.29769.9.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267469856.29769.9.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > arch/arm/mach-msm/smd.c:429: warning: 'smd_dsp_irq_handler' defined
> > but not used
> >   CC      arch/arm/mach-msm/smd_debug.o
> > arch/arm/mach-msm/smd_debug.c:240: warning: initialization from
> > incompatible pointer type
> >   CC      arch/arm/mach-msm/board-dream.o
> > make[1]: *** No rule to make target
> > `arch/arm/mach-msm/board-dream-gpio.o', needed by
> > `arch/arm/mach-msm/built-in.o'.  Stop.
> > make: *** [arch/arm/mach-msm] Error 2
> > 24.39user 5.08system 97.43 (1m37.437s) elapsed 30.24%CPU
> > pavel@amd:/data/l/linux-dwalker-mmc$ emacs .conf
> > 
> > ....maybe board-dream-gpio.c needs to be added to git?
> 
> I pushed a new branch into working-mmc . I added the board-dream-gpio.c
> file.. It's not the one you wrote tho, but eventually it will be. It
> should work now if you want to test it.

How do I get that one? I tried killing the repository and redoing git
pull, followed up by 

git checkout refs/remotes/origin/working-mmc

only to get (git log): [I think I was there before].

commit 2b0bcf161e83fc7d45476f3330f06b656a1f03d4
Author: Daniel Walker <dwalker@codeaurora.org>
Date:   Mon Feb 22 12:29:17 2010 -0800

    DMA fixes (get MMC working).

commit 5fc33446739aa7a0826d98a00cc50a712c6d60eb
Author: San Mehat <san@google.com>
Date:   Wed Feb 3 12:59:29 2010 -0800

    drivers: mmc: msm_sdcc: Add EMBEDDED_SDIO support
    
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
