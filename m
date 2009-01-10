Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbZAJAyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbZAJAyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZAJAyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:54:21 -0500
Received: from mail2.shareable.org ([80.68.89.115]:49045 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZAJAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:54:19 -0500
Date: Sat, 10 Jan 2009 00:53:42 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
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
Message-ID: <20090110005342.GC1972@shareable.org>
References: <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <1231538387.5825.2.camel@brick> <alpine.LFD.2.00.0901091404150.6528@localhost.localdomain> <1231539918.5825.7.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231539918.5825.7.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Oh yeah, and figure out what actually breaks on alpha such that they added
> the following (arch/alpha/include/asm/compiler.h)
> 
> #ifdef __KERNEL__
> /* Some idiots over in <linux/compiler.h> thought inline should imply
>    always_inline.  This breaks stuff.  We'll include this file whenever
>    we run into such problems.  */

Does "always_inline" complain if the function isn't inlinable, while
"inline" allows it?  That would explain the alpha comment.

-- Jamie
