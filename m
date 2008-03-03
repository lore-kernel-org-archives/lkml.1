Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbYCCJPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbYCCJPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYCCJOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:14:50 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53926 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbYCCJOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:14:49 -0500
Date: Mon, 3 Mar 2008 11:13:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303091314.GC4457@cs181133002.pp.htv.fi>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080303085720.GD15943@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 09:57:20AM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Sat, Mar 01, 2008 at 09:26:41PM +0300, Alexey Starikovskiy wrote:
> > > May I keep them inline?
> > 
> > The problem with such manual inlines is that we force gcc to always 
> > inline them - and history has shown that functions grow without the 
> > "inline" being removed.
> 
> what do you mean by "we force gcc to always inline them"?

#define inline          inline          __attribute__((always_inline))

> gcc is free to decide whether to inline or to not inline.

Not with __attribute__((always_inline)).

> (and CONFIG_FORCED_INLINING got removed from 2.6.25)

CONFIG_FORCED_INLINING never had any effect.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

