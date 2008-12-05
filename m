Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYLEHui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYLEHui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYLEHuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:50:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50685
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753106AbYLEHuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:50:11 -0500
Date: Thu, 04 Dec 2008 23:50:11 -0800 (PST)
Message-Id: <20081204.235011.161384440.davem@davemloft.net>
To: mingo@elte.hu
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, paulus@samba.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205061012.GA12785@elte.hu>
References: <20081204225345.654705757@linutronix.de>
	<20081204.171233.201039452.davem@davemloft.net>
	<20081205061012.GA12785@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 5 Dec 2008 07:10:12 +0100

> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Thu, 04 Dec 2008 23:44:39 -0000
> > 
> > >  - No interaction with ptrace: any task (with sufficient permissions) can
> > >    monitor other tasks, without having to stop that task.
> > 
> > This isn't going to work.
> >
> > If you look at the things the perfmon libraries do, you do need to stop 
> > the task.
> >
> > Consider counter virtualization as the most direct example. [...]
> 
> Note that counter virtualization is not offered in the perfmon3 patchset 
> that has been posted to lkml. (It is part of the much larger 'full' 
> perfmon patchset which has not been submitted for integration)

I know, it was yanked out to make a merge more likely.

> Relying on ptrace machinery can be considered one of the bigger design 
> mistakes of the permon3 patchset.

I totally disagree.

> We pointed that out in review, and now we demonstrate it via this 
> patchset that it can be done much cleaner and much simpler. (Please stay 
> tuned for -v2 if you want to see the proof of the pudding.)

I hope it will provide enough for full PAPI library support, otherwise
it's useless for most of the world.
