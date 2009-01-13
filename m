Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbZAMSlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbZAMSlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZAMSkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:40:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbZAMSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:40:54 -0500
Date: Tue, 13 Jan 2009 10:40:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
In-Reply-To: <20090113183310.GA10065@elte.hu>
Message-ID: <alpine.LFD.2.00.0901131038260.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
 <1231867314.7141.16.camel@twins> <20090113183310.GA10065@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Jan 2009, Ingo Molnar wrote:
> 
> below is the v8 -> v10 delta patch - for all who'd like to review the 
> changes.

Hmm. This does seem to indicate that v10 lost many of the preempt changes. 
Probably because Peter went back to v7 to create it.

I also wonder about the timing numbers - the numbers were probably done 
with some random version and then not re-done, so the commit message is 
not necessarily "sane" in that respect - the timings quoted don't 
necessarily match the code committed.

		Linus
