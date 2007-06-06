Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbXFFMbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbXFFMbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763494AbXFFMbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:31:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55172 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752710AbXFFMbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:31:41 -0400
Date: Wed, 6 Jun 2007 14:31:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] kernel/sched{,_fair}.c: make code static
Message-ID: <20070606123145.GM5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070605215056.GJ5500@stusta.de> <20070605235441.7b132e27.akpm@linux-foundation.org> <20070606073023.GA11250@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606073023.GA11250@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 09:30:23AM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > > 
> > > ---
> > > 
> > > BTW: Please don't #include C files in sched.c
> > 
> > Yeah.
> 
> In this case it's not that bad. It makes the source quite a bit cleaner 
> and avoids having to create artificial interfaces, global functions, 
> etc. between the .o's.
>...

The idiom used in the kernel for such code is "global code and compile 
the files separately". The expected inclusion for a C file into the 
kernel is through the Makefile, and everything else is surprising when 
looking through the code.

"artificial interfaces" is not a problem since these are completely 
private interfaces you can change at any time.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

