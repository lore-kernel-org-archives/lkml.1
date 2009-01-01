Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZAAQii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZAAQii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 11:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZAAQi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 11:38:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756266AbZAAQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 11:38:27 -0500
Date: Thu, 1 Jan 2009 08:37:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Helge Deller <deller@gmx.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>, stable@kernel.org
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel
 modules (take 4)
Message-Id: <20090101083732.51694e45.akpm@linux-foundation.org>
In-Reply-To: <20090101142401.GA25690@elte.hu>
References: <4959346E.7060600@gmx.de>
	<200812310915.41693.rusty@rustcorp.com.au>
	<495B5806.3080505@gmx.de>
	<alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
	<ada63l0qmba.fsf@cisco.com>
	<alpine.LFD.2.00.0812310942110.5086@localhost.localdomain>
	<20081231105425.9ccac21d.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
	<20090101142401.GA25690@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 2009 15:24:01 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Wed, 31 Dec 2008, Andrew Morton wrote:
> > > 
> > > Adrian claimed that it was gcc-4.1.0 and 4.1.1 only.  He proposed
> > > banning them: http://lkml.org/lkml/2008/8/5/444
> > 
> > If it really is just those releases, then yes, considering the number of 
> > cases we apparently have, and considering how ugly it is in some cases 
> > to move the weak function anywhere else, maybe banning those versions is 
> > the proper thing to do.
> > 
> > It probably won't hurt very many people - yeah, some people will be 
> > forced to upgrade, but I have this memory of early 4.1 having had other 
> > bugs anyway, so it's probably a good idea.
> 
> That would be _really_ nice to do IMHO

I wonder if we should do it in -stable too.  Probably yes.
