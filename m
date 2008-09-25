Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYIYXfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYIYXfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYIYXfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:35:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbYIYXf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:35:29 -0400
Date: Thu, 25 Sep 2008 16:33:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080925221441.GA29060@elte.hu>
Message-ID: <alpine.LFD.1.10.0809251631460.3265@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu>
 <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org> <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu> <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org>
 <20080925221441.GA29060@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Sep 2008, Ingo Molnar wrote:
> 
> i do not understand this argument of yours. (really)
> 
> 1) is your point that we might lock up?

Have you at all followed the discussion about the people who asked for 
cross-CPU ordering? They wanted not timestamps at all, but global atomic 
counter updates. Which is very reasonable, if timestamps don't work (and 
jiffies certainly doesn't, especially in a NOHZ environment).

IOW, my whole argument is that what tracers want is _not_ the same thing 
as what "sched_clock()" wants.

		Linus
