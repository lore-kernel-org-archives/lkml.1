Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbZDGFDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbZDGFDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZDGFC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:02:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:26757 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZDGFCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:02:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,335,1235980800"; 
   d="scan'208";a="128622315"
Date: Tue, 7 Apr 2009 13:02:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Avan Anishchuk <matimatik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
	updates
Message-ID: <20090407050237.GA14513@localhost>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain> <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain> <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain> <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 12:45:37PM +0800, Linus Torvalds wrote:
> 
> 
> On Mon, 6 Apr 2009, Linus Torvalds wrote:
> > 
> > It bisected past them. I'm getting worried that it's timing-related, 
> > because nothing that remains looks even remotely interesting for that Mac 
> > mini, but right now:
> > 
> >  - bad: 56fcef75117a153f298b3fe54af31053f53997dd
> >  - good: bb233fdfc7b7cefe45bfa2e8d1b24e79c60a48e5
> > 
> > and there's not a whole lot of commits in between.
> 
> It's c3b1b1cbf002e65a3cabd479e68b5f35886a26db: 'ramfs: add support for 
> "mode=" mount option'.
> 
> And I checked. Reverting it at the tip fixes it. So no random timing 
> fluctuations.
> 
> So that commit causes some random SLAB corruption, that then (depending 
> apparently on luck) may or may not crash in some odd random places later.
> 
> Wu?

DON'T PANIC!  -- The Hitchhiker's Guide to the Galaxy

I'm looking into this :)

Thanks,
Fengguang

