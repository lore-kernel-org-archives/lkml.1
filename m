Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYFKKAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYFKKAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYFKKA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:00:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36383 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYFKKA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:00:26 -0400
Date: Wed, 11 Jun 2008 12:59:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] always enable FW_LOADER unless EMBEDDED=y
Message-ID: <20080611095921.GN11685@cs181133002.pp.htv.fi>
References: <20080610160408.GB11685@cs181133002.pp.htv.fi> <20080610162450.GB13538@kroah.com> <20080610181206.GF11685@cs181133002.pp.htv.fi> <20080610212859.GB26249@kroah.com> <20080611082320.GM11685@cs181133002.pp.htv.fi> <484F98C5.3040202@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <484F98C5.3040202@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 12:20:05PM +0300, Boaz Harrosh wrote:
> Adrian Bunk wrote:
> > 
> > [1] and before anyone restarts the "kconfig is broken - select should 
> >     follow dependencies" FUD: I've seen much talk and zero code for
> >     this, and in my opinion the problem is much more difficult than
> >     it appears at first sight
> 
> I had this crazy idea, Perhaps it would be easier to reverse the problem.
> Introduce a kind of Lazy_Enable mode. Which means config is enabled but
> gets it's use_count bumped up every time someone is dependent on it.
> At the end, for optimization, any Lazy_Enable with zero count, is dropped.
> Is that at all possible in current infrastructure?
> (I admit I never looked at the source)

Wouldn't your "Lazy_Enable" do the same as "select" already does?

> Boaz

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

