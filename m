Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbXI2UXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbXI2UXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbXI2UXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:23:17 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44562 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbXI2UXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:23:17 -0400
Date: Sat, 29 Sep 2007 22:24:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Adrian Bunk <bunk@kernel.org>,
       roel <12o3l@tiscali.nl>
Subject: Re: [OT] kbuild syntax extension for ccflags and asflags (was: [PATCH 1/3] CodingStyle updates)
Message-ID: <20070929202444.GA20884@uranus.ravnborg.org>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu> <20070929110129.307cbd9f.randy.dunlap@oracle.com> <20070929182909.GA19943@uranus.ravnborg.org> <200709292221.27534.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709292221.27534.ioe-lkml@rameria.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Lately I have considered extending the kbuild syntax a bit.
> > 
> > Introducing
> > ccflags-y
> > asflags-y
> > 
> > [with same functionality as the EXTRA_CFLAGS, EXTRA_AFLAGS]
> > would allow us to do:
> > 
> > ccflags-$(CONFIG_WHATEVER_DEBUG) := -DDEBUG
> 
> Please do!
> 
> That is very useful for testing and developing new modules.
> I learnt a lot from you in this regard and used that kind
> of syntax to the extreme in some other non-kernel project
> of mine. There it included also ccflags, asflags and so on.
> 
> I further split that into -debug-y and -optimize-y flags,
> but that was just for my own convenience.

Thanks for feedback Ingo.
I just started a new thread were I outlined the ideas I have
for further extending (some may say uglifying) the kbuild syntax.
I will see the outcome of this thread before implmenting something.

PS. The implementation part is obviously trivial, the
hard part is the documentation :-)

	Sam
