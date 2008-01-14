Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbYANSV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbYANSV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYANSVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:21:52 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:43230 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbYANSVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:21:51 -0500
Date: Mon, 14 Jan 2008 20:20:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114182052.GB9847@does.not.exist>
References: <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150103.GA2700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080114150103.GA2700@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 04:01:03PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Would be great to have them automated - just dunno how to do it. Do 
> > > you see a feasible way to do it?
> > 
> > a good starting point would be to make the warnings a lot more 
> > self-explanatory. Right now it's often non-obvious trying to figure 
> > out how the dependencies are structured and which one should be 
> > changed to get rid of the bug.
> 
> for example, in current -git, could you tell me why this triggers:
> 
>  WARNING: vmlinux.o(.text+0x87e2a): Section mismatch: reference to 
>           .init.text: (between 'process_zones' and 'setup_per_cpu_pageset')
> 
> and how to resolve it? I had a quick look and it was not obvious to me.

Please send the .config.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

