Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYGLD3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYGLD3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGLD3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:29:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbYGLD3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:29:12 -0400
Date: Fri, 11 Jul 2008 20:28:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <20080712031736.GA3040@damson.getinternet.no>
Message-ID: <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Vegard Nossum wrote:
> 
> Can somebody else please test/ack/review it too? This should eventually
> go into 2.6.26 if it doesn't break anything else.

And Dmitry, _please_ also explain what was going on. Why did things break 
from calling common_cpu_mem_hotplug_unplug() too much? That function is 
called pretty randomly anyway (for just about any random CPU event), so 
why did it fail in some circumstances?

		Linus
