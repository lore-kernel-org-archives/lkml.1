Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbYANTyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbYANTyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYANTx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:53:58 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41810 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYANTx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:53:57 -0500
Date: Mon, 14 Jan 2008 21:52:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114195258.GC9847@does.not.exist>
References: <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150103.GA2700@elte.hu> <20080114182052.GB9847@does.not.exist> <20080114191009.GB2288@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080114191009.GB2288@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 08:10:09PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > for example, in current -git, could you tell me why this triggers:
> > > 
> > >  WARNING: vmlinux.o(.text+0x87e2a): Section mismatch: reference to 
> > >           .init.text: (between 'process_zones' and 'setup_per_cpu_pageset')
> > > 
> > > and how to resolve it? I had a quick look and it was not obvious to me.
> > 
> > Please send the .config.
> 
> 'make allyesconfig' and disable CONFIG_HOTPLUG=y.

Works for me without the warning.

Wait, I remember something @#$%#@$!!!:
'make allyesconfig' on x86 became ambiguously.

If you have by chance a 64bit CPU that would explain why I didn't get it.

@Sam:
Can you fix the bug that menuconfig does not let me enable CONFIG_64BIT?

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

