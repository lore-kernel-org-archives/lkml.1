Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYGMSjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYGMSjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYGMSjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:39:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbYGMSjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:39:31 -0400
Date: Sun, 13 Jul 2008 11:38:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <20080713181910.GA22052@elte.hu>
Message-ID: <alpine.LFD.1.10.0807131136350.2959@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org> <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
 <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com> <alpine.LFD.1.10.0807121607160.2959@woody.linux-foundation.org> <b647ffbd0807130253t32904430x5ca942783d01ce99@mail.gmail.com> <alpine.LFD.1.10.0807130943530.2959@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807131041240.2959@woody.linux-foundation.org> <b647ffbd0807131113o7103215u823e71fb4aa92e17@mail.gmail.com> <20080713181910.GA22052@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Ingo Molnar wrote:
> 
> mind sending Linus's patch as a completed patchset against tip/master 
> (or tip/sched/devel) so that we can do it in early v2.6.27?

Note that my patch does need lots more eyes and more testing, since it 
needs to make sure that anything that depended on online_map and/or just 
on the scheduling domains now checks active_map instead (or in addition 
to).

> i still think your cpusets.c fix is what we should do for v2.6.26, given 
> that there's agreement about how to fix it for real and thus in terms of 
> regression/bug risk your patch is lower-impact and CPU hotplug has been 
> broken for such a long time.

Agreed. I've pulled it from your tree.

		Linus
