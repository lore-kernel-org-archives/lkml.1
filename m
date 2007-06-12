Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbXFLBME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbXFLBME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbXFLBLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:11:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60240 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756011AbXFLBLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:11:51 -0400
Date: Tue, 12 Jun 2007 03:12:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org, Mark Lord <lkml@rtr.ca>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070612011202.GT3588@stusta.de>
References: <20070608023551.GJ15426@holomorphy.com> <20070611235235.GR3588@stusta.de> <20070612000026.GC6909@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070612000026.GC6909@holomorphy.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 05:00:26PM -0700, William Lee Irwin III wrote:
> On Thu, Jun 07, 2007 at 07:35:51PM -0700, William Lee Irwin III wrote:
> >> +	  PAE is required for NX support, and furthermore enables
> >> +	  larger swapspace support for non-overcommit purposes. It
> >> +	  has the cost of more pagetable lookup overhead, and also
> >> +	  consumes more pagetable space per process.
> 
> On Tue, Jun 12, 2007 at 01:52:35AM +0200, Adrian Bunk wrote:
> > It's not specific to this help text, but I start becoming a bit picky 
> > about this issues:
> > If you understand this help text after reading it, you don't need a help 
> > text for this option...  ;-)
> > What is "NX support"?
> > What are "non-overcommit purposes"?
> > What is "pagetable lookup overhead"?
> > And if in doubt, should I say Y or N?
> > "System administrator who knows which hardware components he put into 
> > the computer and which filesystems his data is on" might be a good 
> > description for the average kconfig user, and these are the people who 
> > should understand this help text.
> 
> I would like to have some place to explain issues such as those, but
> there are as of yet no designated places for tutorial-level information.
>  
> If such a place were provided, I would provide storybook commentary to
> explain all those. Similarly actually holds for kernel function docbook.

There's no 4 line limit for Kconfig entries. If it takes a 10 line 
paragraph for a short explanation what the NX bit is and when enabling 
NX support makes sense (because it will be used) then that's completely 
appropriate here. The same goes for the other parts.

The kconfig help should give anyone running "make oldconfig" a rough 
understanding what this option is about and a clear understanding what 
to answer for this option ("If unsure, say Y/N." is a standard text we 
use for the latter).

> -- wli

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

