Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZALAWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZALAWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 19:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZALAWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 19:22:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbZALAWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 19:22:20 -0500
Date: Sun, 11 Jan 2009 16:21:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
In-Reply-To: <20090112001255.GR26290@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain>
References: <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org> <1231676801.25018.150.camel@macbook.infradead.org> <20090111181307.GM26290@one.firstfloor.org> <alpine.LFD.2.00.0901111114230.6528@localhost.localdomain>
 <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain>
 <20090112001255.GR26290@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jan 2009, Andi Kleen wrote:
> 
> so at least least for this case it works. Your case also doesn't work 
> for me. So it looks like gcc didn't like something you did in your test 
> program.

I very intentionally used _different_ types.

If you use the same type, gcc will apparenrly happily say "hey, I can 
combine two variables of the same type with different liveness into the 
same variable".

But that's not the interesting case.

			Linus
