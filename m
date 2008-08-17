Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYHQPko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYHQPko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYHQPkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:40:36 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59184 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYHQPkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:40:35 -0400
Date: Sun, 17 Aug 2008 18:38:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, davem@davemloft.net,
       Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27-rc3 - build failure: undefined reference to
	`.lockdep_count_forward_deps'
Message-ID: <20080817153823.GB24619@cs181140183.pp.htv.fi>
References: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org> <jefxp8ofmz.fsf@sykes.suse.de> <200808162111.23914.elendil@planet.nl> <alpine.LFD.1.10.0808161720470.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808161720470.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 05:21:31PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 16 Aug 2008, Frans Pop wrote:
> 
> > Andreas Schwab wrote:
> > >> David Miller (3):
> > >>       lockdep: fix combinatorial explosion in lock subgraph traversal
> > > 
> > > lockdep_count_forward_deps is only defined if CONFIG_PROVE_LOCKING but
> > > used unconditionally in lockdep_proc.c.
> > > 
> > > kernel/built-in.o: In function `.lockdep_stats_show':
> > > lockdep_proc.c:(.text+0x3fea8): undefined reference to `.lockdep_count_forward_deps'
> > > kernel/built-in.o: In function `.l_show': 
> > > lockdep_proc.c:(.text+0x401f0): undefined reference to `.lockdep_count_forward_deps'
> > > lockdep_proc.c:(.text+0x40210): undefined reference to `.lockdep_count_backward_deps'
> > 
> > I have so far been unable to build -rc3 because of this same error.
> > Just tried again with current git HEAD. Failing config attached.
> 
> Ok, I think this one is fixed by df60a8441866153d691ae69b77934904c2de5e0d, 
> just pushed out.

Confirmed, bug closed.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

