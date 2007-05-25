Return-Path: <linux-kernel-owner+w=401wt.eu-S1764184AbXEYQuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764184AbXEYQuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761248AbXEYQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:50:05 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbXEYQuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:50:03 -0400
Date: Fri, 25 May 2007 09:49:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
In-Reply-To: <20070525120228.GA7186@elte.hu>
Message-ID: <alpine.LFD.0.98.0705250946120.26602@woody.linux-foundation.org>
References: <20070525084547.GJ8094@one.firstfloor.org>
 <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org>
 <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org>
 <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org>
 <20070525112600.GA27007@elte.hu> <20070525115004.GA4574@elte.hu>
 <20070525115544.GP8094@one.firstfloor.org> <20070525120228.GA7186@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Ingo Molnar wrote:
> 
> ok - then please merge that single hunk into the paravirtops patch - and 
> leave the other 6 hunks in this patch.

Note: I'm actually much more interested in applying the scheduler changes 
than the paravirt-ops changes. It looks like CFS is getting stable, I'd 
much rather have Ingo working on making a nice CFS patch on top of 2.6.22 
(and the current -git tree should obviously approximate that, I don't 
expect any real changes to scheduler stuff), and merge that immediately 
after 2.6.22 is out. 

Ingo: to make things easier, the _best_ split-up would be not "this is the 
historical series of patches leading up to CFS v15" or something like 
that, but it would be nice to get that final CFS version as a series of 
patches that do some specific things rather than as one final one. Is 
there any possibility that could happen? 

		Linus
