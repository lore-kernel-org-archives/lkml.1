Return-Path: <linux-kernel-owner+w=401wt.eu-S934283AbXEPXmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283AbXEPXmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbXEPXmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:42:31 -0400
Received: from omta02ps.mx.bigpond.com ([144.140.83.154]:59213 "EHLO
	omta02ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbXEPXma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:42:30 -0400
Message-ID: <464B96DD.2000706@bigpond.net.au>
Date: Thu, 17 May 2007 09:42:21 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au> <20070516080843.GA8909@elte.hu>
In-Reply-To: <20070516080843.GA8909@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02ps.mx.bigpond.com from [138.130.234.53] using ID pwil3058@bigpond.net.au at Wed, 16 May 2007 23:42:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
> 
>>> As usual, any sort of feedback, bugreport, fix and suggestion is more 
>>> than welcome,
>> Load balancing appears to be badly broken in this version.  When I 
>> started 4 hard spinners on my 2 CPU machine one ended up on one CPU 
>> and the other 3 on the other CPU and they stayed there.
> 
> hm, i cannot reproduce this on 4 different SMP boxen, trying various 
> combinations of SCHED_SMT/MC

You may need to try more than once.  Testing load balancing can be a 
pain as there's always a possibility you'll get a good result just by 
chance.  I.e. you need a bunch of good results to say it's OK but only 
one bad result to say it's broken.   This makes testing load balancing a 
pain.

> and other .config options that might make a 
> difference to balancing. Could you send me your .config?

Sent separately.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
