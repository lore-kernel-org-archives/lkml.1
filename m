Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZAISFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZAISFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZAISFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:05:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52172 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZAISFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:05:41 -0500
Date: Fri, 9 Jan 2009 19:19:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Dirk Hohndel <hohndel@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
       Chris Mason <chris.mason@oracle.com>,
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
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Message-ID: <20090109181952.GI26290@one.firstfloor.org>
References: <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109173914.GD6936@parisc-linux.org> <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So we do have special issues. And exactly _because_ we have special issues 
> we should also expect that some compiler defaults simply won't ever really 
> be appropriate for us.

I agree that the kernel needs quite different inlining heuristics
than let's say a template heavy C++ program. I guess that is 
also where our trouble comes from -- gcc is more tuned for the
later. Perhaps because the C++ programmers are better at working
with the gcc developers?

But it's also not inconceivable that gcc adds a -fkernel-inlining or
similar that changes the parameters if we ask nicely. I suppose
actually such a parameter would be useful for far more programs
than the kernel.

-Andi

-- 
ak@linux.intel.com
