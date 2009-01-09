Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZAISLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZAISLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZAISLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:11:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbZAISLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:11:06 -0500
Message-ID: <49679270.1090600@zytor.com>
Date: Fri, 09 Jan 2009 10:07:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Dirk Hohndel <hohndel@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz,
       richard.guenther@gmail.com
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
References: <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109173914.GD6936@parisc-linux.org> <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> So we do have special issues. And exactly _because_ we have special issues 
> we should also expect that some compiler defaults simply won't ever really 
> be appropriate for us.
> 

That is, of course, true.

However, the Linux kernel (and quite a few other kernels) is a very 
important customer of gcc, and adding sustainable modes for the kernel 
that we can rely on is probably something we can work with them on.

I think the relationship between the gcc and Linux kernel people is 
unnecessarily infected, and cultivating a more constructive relationship 
would be good.  I suspect a big part of the reason for the oddities is 
that the timeline for the kernel community from making a request into 
gcc until we can actually rely on it is *very* long, and so we end up 
having to working things around no matter what (usually with copious 
invective), and the gcc people have other customers with shorter lead 
times which therefore drive their development more.

	-hpa
