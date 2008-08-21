Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYHUP7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYHUP7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYHUP6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:58:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbYHUP6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:58:53 -0400
Date: Thu, 21 Aug 2008 08:57:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4
 released
In-Reply-To: <20080821114745.GD21089@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.1.10.0808210845280.3487@nehalem.linux-foundation.org>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de> <1219316568.8651.107.camel@twins> <20080821114745.GD21089@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, Paul E. McKenney wrote:
> 
> Let's face it, the C standard does not support concurrency, so we are
> all in a state of sin in any case, forced to rely on combinations of
> gcc-specific non-standard language extensions and assembly language.
> 
> Could be worse!!!

It _will_ be worse.

The C standard will eventually support concurrency (they are working on 
it), and it will almost inevitably be a horrible pile of stinking sh*t, 
and we'll continue to use the gcc inline asms instead, but then the gcc 
people will ignore our complaints when they break the compiler, and say 
that we should use the stinking-pile-of-sh*t ones that are built in.

No, I haven't seen the drafts, and maybe I'm overly pessimistic, but I'm 
pretty sure that this is an area where (a) the kernel needs more support 
than most normal pthread-like models and (b) any design-by-committee thing 
simply won't be very good, because they'll have to try to make everybody 
happy.

Oh, well.

		Linus
