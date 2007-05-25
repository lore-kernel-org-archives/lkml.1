Return-Path: <linux-kernel-owner+w=401wt.eu-S1762703AbXEYMRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703AbXEYMRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761779AbXEYMPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:15:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54759 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761765AbXEYMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:15:42 -0400
Date: Fri, 25 May 2007 14:15:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups, #2
Message-ID: <20070525121540.GA24083@one.firstfloor.org>
References: <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu> <20070525115004.GA4574@elte.hu> <20070525115544.GP8094@one.firstfloor.org> <20070525120228.GA7186@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525120228.GA7186@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 02:02:28PM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > find below the cleanups from my first patch that didnt make it into 
> > > your cleanups. (plus one more cleanup i noticed while merging the 
> > > missing bits from my first patch) Goes after the bugfix i just sent. 
> > > Please apply.
> > 
> > I cannot apply it as is because it changes code from the paravirtops 
> > patch too.
> 
> ok - then please merge that single hunk into the paravirtops patch - and 
> leave the other 6 hunks in this patch.

I added the empty lines too.

> 
> > BTW to nitpick the original formattings you changed are all probably 
> > standard code style and the new comment is a classical i++; /* 
> > Increase i */
> 
> could you please quote the portion from my patch that you are talking 
> about?

-static int sc_freq_event(struct notifier_block *nb, unsigned long event,
-                        void *data)
+static int
+sc_freq_event(struct notifier_block *nb, unsigned long event, void *data)

and

+               /*
+                * Still no frequency? Then fall back to tsc_khz:  
+                */
                if (!freq->new)
                        freq->new = tsc_khz;


-Andi (who hopes this thread will end soon now and we can all go
back to more important issues)

