Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbXEGOGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbXEGOGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbXEGOGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:06:08 -0400
Received: from main.gmane.org ([80.91.229.2]:44359 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbXEGOGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:06:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [patch] CFS scheduler, -v9
Date: Mon, 07 May 2007 10:03:46 -0400
Message-ID: <463F31C2.1070809@tmr.com>
References: <20070503140911.GA21916@elte.hu> <4d47a5d10705070302k3f081074k89f0122cee7ae2e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <4d47a5d10705070302k3f081074k89f0122cee7ae2e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> Hi Ingo,
> 
> I just thought I would mention this, because it is certainly on my 
> mind. I can't help wondering if other folks are also concerned about
> this. The thing is, why don't you just send your patches to Con who
> got this whole ball rolling and did a bunch of great work, proving
> beyond any reasonable doubt that he is capable of maintaining this
> subsystem, whatever algorithm is finally adopted? Are you worried 
> that Con might steal your thunder? That somehow the scheduler is
> yours alone? That you might be perceived as less of a genius if
> somebody else gets credit for their good work? NIH?
> 
> My perception is that you barged in to take over just when Con got 
> things moving after the scheduler sat and rotted for several years.
> If that is in any way accurate, then shame on you.
> 
Clearly you have no idea what's going on, or how development is done. 
These are mutually exclusive different ideas on what constitutes an 
optimal scheduler, and not in any way improvements on the same thing, 
but total replacements for the algorithm of the scheduler.

And Ingo has been doing scheduler work for a very long time, while until 
recently Con was working on the staircase scheduler as a solution for 
desktop use, and it was not (to my taste) a candidate for a general 
scheduler until the deadline discussion and some ideas from wli resulted 
in improvements resulting in more robust performance under typical 
server loads.

You also seem to be unaware of the work done by Nick Piggin in 
nicksched. There are a lot of mutually incompatible approaches being 
evaluated, and that's good for the future.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

