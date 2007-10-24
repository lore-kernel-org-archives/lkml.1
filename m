Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbXJXQ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbXJXQ73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764292AbXJXQpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:45:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41355 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764296AbXJXQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:45:48 -0400
Date: Wed, 24 Oct 2007 18:46:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 cpufreq.c:cpufreq_get()
Message-ID: <20071024164616.GY30533@stusta.de>
References: <20071024162312.GH30533@stusta.de> <20071024163245.GF32333@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071024163245.GF32333@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 05:32:45PM +0100, Russell King wrote:
> On Wed, Oct 24, 2007 at 06:23:12PM +0200, Adrian Bunk wrote:
> > cpufreq.c:cpufreq_get() no longer has any user.
> 
> Your checking seems to be flawed.
> 
> drivers/video/sa1100fb.c:               cpufreq_get(smp_processor_id()));
> drivers/video/sa1100fb.c:       pcd = get_pcd(var->pixclock, cpufreq_get(0));

Thanks for spotting this.

My mistake was that I thought this was handled by the following without 
checking closer:

arch/arm/mach-sa1100/generic.c:unsigned int cpufreq_get(unsigned int cpu)
arch/arm/mach-sa1100/generic.c:EXPORT_SYMBOL(cpufreq_get);

> Russell King

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

