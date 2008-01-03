Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYACSPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYACSPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYACSPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:15:00 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41892 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYACSO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:14:59 -0500
Date: Thu, 3 Jan 2008 20:14:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080103181438.GA7141@does.not.exist>
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080103154229.9723F14DDD@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 04:42:29PM +0100, Andi Kleen wrote:
> 
> This avoids the requirement to mark a lot of initialization functions not 
> __cpuinit just for resume from RAM.
> 
> More functions could be converted now, didn't do all.
>...

Shouldn't this aready be handled by the following?

config PM_SLEEP_SMP
        bool
        depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
        depends on PM_SLEEP
        select HOTPLUG_CPU
        default y


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

