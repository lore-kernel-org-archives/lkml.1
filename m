Return-Path: <linux-kernel-owner+w=401wt.eu-S2993360AbXEBP1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993360AbXEBP1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993361AbXEBP1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:27:34 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35764 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993360AbXEBP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:27:33 -0400
Date: Wed, 2 May 2007 17:27:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Olaf Hering <olh@suse.de>,
       Kristian =?utf-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [git pull] New firewire stack
Message-ID: <20070502152732.GG3531@stusta.de>
References: <4637A29F.6070302@redhat.com> <20070502122147.GA31215@suse.de> <4638888B.4080908@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4638888B.4080908@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 02:48:11PM +0200, Stefan Richter wrote:
> Olaf Hering wrote:
> > On Tue, May 01, Kristian Høgsberg wrote:
> > 
> >>   drivers/firewire/Kconfig          |   60 ++
> > 
> > NACK.
> > Upgrade the current drivers/ieee1394/ with the new code,
> 
> Last time I believe I was the only one who asked whether to put it into
> drivers/ieee1394 instead of another directory.  Of course I acknowledge
> that everytime a new review round is started, people do reconsider.
> Especially since we had a gap of a few months since the last LKML review.
> 
> > and keep all existing module names.
> 
> I'm impartial to that.  Using same names might ease the transition from
> the userspace side, as far as there is userland which relies on module
> names.
> 
> A certain drawback of same names would be that geeks cannot install both
> stacks at once during the transition period.  Therefore, checking
> whether eventual problems are in fact regressions involves a module
> unload/ configure/ build/ install/ reload cycle, instead of just module
> unload/ reload.  This especially means we can only get help from testers
> who are able to build kernels.
> 
> Other opinions?

An advantage of changing the names is that they are now prefixed.
But looking at them, there will again be the point whether everyone will 
think that "fw" is firmware, and perhaps switching to the (although 
longer) prefix "firewire" might make sense?

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

