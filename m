Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZFPLa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZFPLa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZFPLaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:30:20 -0400
Received: from www.tglx.de ([62.245.132.106]:45437 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZFPLaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:30:19 -0400
Date: Tue, 16 Jun 2009 13:29:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [GIT pull] ntp updates for 2.6.31
In-Reply-To: <20090616090647.GD13771@elte.hu>
Message-ID: <alpine.LFD.2.00.0906161322330.2800@localhost.localdomain>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain> <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com> <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com> <20090616090647.GD13771@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Ingo Molnar wrote:
> Each OS should converge back to the correct time _as fast as 
> physically possible_. If this is a problem and if someone wants 
> crappy time and longer periods of convergence for some odd reason 
> then that header file change can be edited by hand even. It's not 
> like it's that hard to change, if there's genuine interest.
> 
> So i'm against any revert on this basis. If another basis comes up 
> we can reconsider of course. What do you think?

I completely agree. 

Consistent convergence across different OSs is a wet dream. 

We see even different behaviour across kernel versions :) Also I
recently looked at an embedded system running the same kernel version
as a PC in the same network. Same version of user space tools. Main
difference aside the arch was HZ (100 vs. 1000). The PC convergence
time was about 40% higher than the embedded systems.

Thanks,

	tglx
