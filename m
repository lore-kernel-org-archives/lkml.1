Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYAJL1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYAJL1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYAJL0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:26:54 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46537 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYAJL0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:26:54 -0500
Date: Thu, 10 Jan 2008 13:26:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080110112607.GE28740@does.not.exist>
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de> <20080103181438.GA7141@does.not.exist> <200801031943.43828.ak@suse.de> <20080110095407.GB28740@does.not.exist> <20080110095857.GN25945@bingen.suse.de> <20080110101928.GC28740@does.not.exist> <20080110111514.GS25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080110111514.GS25945@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 12:15:15PM +0100, Andi Kleen wrote:
> > But your patch does:
> > 
> > +config PM_CPUINIT
> > +       bool
> > +       depends on PM
> 
> That is because arch/x86/power/cpu.c where this happens is currently
> 
> obj-$(CONFIG_PM)                += cpu.o
> 
> If it was changed to CONFIG_something else then yes that dependency
> should be changed too.


Then fix this first.


And the following other points you didn't bother to reply to also still 
stand even after this fix:
- already __cpuinit code will waste memory with CONFIG_PM_SLEEP=y
- change shouldn't be x86 specific


> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

