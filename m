Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYAOWw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYAOWw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbYAOWwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:52:21 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55853 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbYAOWwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:52:20 -0500
Date: Wed, 16 Jan 2008 00:51:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080115225117.GB4449@does.not.exist>
References: <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150103.GA2700@elte.hu> <20080114182052.GB9847@does.not.exist> <20080114191009.GB2288@elte.hu> <20080114195258.GC9847@does.not.exist> <20080114200126.GB9257@uranus.ravnborg.org> <20080114201826.GD9847@does.not.exist> <20080115221409.GF2665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080115221409.GF2665@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 11:14:09PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > make ARCH=x86_64 allyesconfig
> > > will set CONFIG_64BIT for you - no?
> > 
> > Yes.
> > 
> > But this still leaves the fact that when someone says 'allyesconfig' 
> > it's no longer clear which configuration he has. And no, I do not 
> > consider it funny that this now implies two hours of compilation twice 
> > just for seeing one bug.
> 
> sorry - i should have mentioned that it's 64-bit. (and i even 
> mis-remembered having seen it on 32-bit as well)

This bug seems to also be present on 32bit, but allyesconfig minus 
CONFIG_HOTPLUG is not among the configurations where it's present
on 32bit.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

