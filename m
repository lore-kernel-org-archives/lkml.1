Return-Path: <linux-kernel-owner+w=401wt.eu-S1762377AbXHYBIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377AbXHYBIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 21:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbXHYBIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 21:08:24 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54877 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911AbXHYBIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 21:08:23 -0400
Date: Sat, 25 Aug 2007 03:07:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       dtor@mail.ru, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070825010704.GK30705@stusta.de>
References: <20070821005718.GD3658@interface.famille.thibault.fr> <20070821130233.58faaa8a.akpm@linux-foundation.org> <20070821202251.GB3658@interface.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070821202251.GB3658@interface.famille.thibault.fr>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 10:22:51PM +0200, Samuel Thibault wrote:
> Hi,
> 
> Andrew Morton, le Tue 21 Aug 2007 13:02:33 -0700, a écrit :
> > On Tue, 21 Aug 2007 02:57:18 +0200
> > Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > 
> > > Some external modules like Speakup need to use the PC keyboard to control
> > > them and also need to get keyboard feedback (caps lock status, etc.)
> > > 
> > > This adds a keyboard notifier that such modules can use to get the keyboard
> > > events and possibly eat them, at several stages:
> > 
> > Adding hooks for non-merged modules is considered sinful.  Making these new
> > exports EXPORT_SYMBOL_GPL might ease the pain.
> 
> That should be fine.
> 
> I'll soon propose a notifier for the console writes too, same story.
> 
> > Is there any prospect of getting at least one of these "external modules
> > like Speakup" merged into mainline?
> 
> I'm working on it.  The problem is that the current code quality is
> still far from mainline requirements (though improving over time).  This
> hook (and the other one I'll post) is a step toward merging.  If these
> hooks can go mainline, then great, that will make life easier for the
> few distributions that want to provide speakup as modules. 

How long does it take you for getting the first users submitted for 
review? If you are working on it it should be in the order of "a few 
months", and earlier merging would anyway gain you only one or two 
kernel releases.

> If they
> remain in -mm for some time and people don't complain, well that's good
> too: at least we know how speakup may hook into the kernel when it gets
> merged.
>...

Without any users it's dead code noone uses, and complaints will most 
likely not occur until you submit the first users for review...

> Samuel

cu
Adrian

BTW: Are these the speakup patches that were in -ac five years ago?

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

