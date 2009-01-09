Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbZAIRsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbZAIRsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZAIRsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:48:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45799 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZAIRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:48:03 -0500
Date: Fri, 9 Jan 2009 19:02:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dirk Hohndel <hohndel@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       jim owens <jowens@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Message-ID: <20090109180213.GH26290@one.firstfloor.org>
References: <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109094142.367012b6@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109094142.367012b6@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that's the point. gcc will not get it right. 

I don't think that's necessary an universal truth. It 
can be probably fixed.

> So we need to do it ourselves in the kernel sources.
> We may not like it, but it's the only way to guarantee reproducable
> reliable inline / noinline decisions.

For most things we don't really need it to be reproducable,
the main exception are the inlines in headers.

Universal noinline would also be a bad idea because of its
costs (4.1% text size increase). Perhaps should make it
a CONFIG option for debugging though.

-Andi



> 
> /D
> 
> -- 
> Dirk Hohndel
> Intel Open Source Technology Center
> 

-- 
ak@linux.intel.com
