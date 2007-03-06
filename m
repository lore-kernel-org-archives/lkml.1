Return-Path: <linux-kernel-owner+w=401wt.eu-S965809AbXCFGtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965809AbXCFGtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 01:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965808AbXCFGtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 01:49:51 -0500
Received: from nn7.de ([85.214.94.156]:32847 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965809AbXCFGtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 01:49:50 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Soeren Sonnenburg <kernel@nn7.de>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S\. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <1173140753.24738.246.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015040.GJ3441@stusta.de>
	 <1173138193.24738.236.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
	 <1173140753.24738.246.camel@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Mar 2007 07:49:43 +0100
Message-Id: <1173163783.3785.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 01:25 +0100, Thomas Gleixner wrote:
> On Mon, 2007-03-05 at 15:45 -0800, Linus Torvalds wrote:
> > 
> > On Tue, 6 Mar 2007, Thomas Gleixner wrote:
> > > > 
> > > > Subject    : macbook pro suspend to ram broken  (clockevents)
> > > > References : http://lkml.org/lkml/2007/3/4/110
> > > > Submitter  : Soeren Sonnenburg <kernel@nn7.de>
> > > > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> > > >              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> > > > Status     : unknown
> > > 
> > > I can reproduce this on my dual core VAIO. There are some issues:
> > 
> > Yeah, I think I can too, on my dual-core Mac Mini. 
> > 
> > I'm not done with my bisection, but e9e2cdb4 is among the 28 commits left, 
> > so I'm pretty sure I'm hitting the same bug. I'll do a few more bootups to 
> > be 100% sure.
> 
> I just got the resume fix cleaned up. The suspend / resume thing was
> dropped unintentionally during the -mm code reshuffling.
> 
> It still needs the broadcast fix though.
> 
> Does this make the problem go away ?

yes. works in my isolated test-setup. I'm now going to test this in
git-HEAD with the full config.

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
