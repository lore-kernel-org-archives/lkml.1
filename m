Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZAETpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZAETpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZAEToz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:44:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbZAEToz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:44:55 -0500
Date: Mon, 5 Jan 2009 11:44:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] cpumask: update pci_bus_show_cpuaffinity to use
 new cpumask API
In-Reply-To: <200901051127.03598.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.0901051139410.3057@localhost.localdomain>
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <20090104131800.317064000@polaris-admin.engr.sgi.com> <200901051127.03598.jbarnes@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Jan 2009, Jesse Barnes wrote:
> 
> Can you resend these two against my linux-next branch?

Btw, Jesse, what's the schedule for merging the pci thing.

I'm currently planning on -rc1 next weekend, which gives us time to do at 
least a shortened -rc2 before people are at LCA. And the suspend/resume 
changes are some of the more "exciting" (aka scary) parts of the whole 
merge window, so I'd rather get them merged with a few days to go, rather 
than just before -rc1.

In fact, they are probably more scary than the cpumask changes, since at 
least the cpumask issues are likely to not be a big deal with any normal 
sane config (ie you really do have to enable MAXSMP to hit the stack usage 
issues). So if you end up waiting for those, I'd rather prefer to first 
merge the rest of the PCI code.

Or did the PCI late-suspend/early-resume patches go in somebody elses 
tree and I'm barking up the wrong tree entirely?

			Linus
