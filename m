Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbZAJBFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbZAJBFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZAJBFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:05:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688AbZAJBFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:05:31 -0500
Date: Fri, 9 Jan 2009 17:04:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jamie Lokier <jamie@shareable.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <20090110005342.GC1972@shareable.org>
Message-ID: <alpine.LFD.2.00.0901091701010.6528@localhost.localdomain>
References: <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>
 <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <1231538387.5825.2.camel@brick> <alpine.LFD.2.00.0901091404150.6528@localhost.localdomain> <1231539918.5825.7.camel@brick> <20090110005342.GC1972@shareable.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Jan 2009, Jamie Lokier wrote:
> 
> Does "always_inline" complain if the function isn't inlinable, while
> "inline" allows it?  That would explain the alpha comment.

I suspect it dates back to gcc-3.1 days. It's from 2004. And the author of 
that comment is a part-time gcc hacker who was probably offended by the 
fact that we thought (correctly) that a lot of gcc inlining was totally 
broken.

Since he was the main alpha maintainer, he got to do things his way 
there..

			Linus
