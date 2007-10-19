Return-Path: <linux-kernel-owner+w=401wt.eu-S967175AbXJSWTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967175AbXJSWTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966844AbXJSWTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:19:42 -0400
Received: from www.tglx.de ([62.245.132.106]:51130 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966783AbXJSWTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:19:41 -0400
Date: Sat, 20 Oct 2007 00:19:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Git pull] arch/x86 updates
In-Reply-To: <alpine.LFD.0.999.0710191459340.26902@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0710200018170.22770@localhost.localdomain>
References: <alpine.LFD.0.9999.0710192334440.22770@localhost.localdomain> <alpine.LFD.0.999.0710191459340.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Linus Torvalds wrote:
>>
> > Pavel Emelyanov (1):
> >       i386: consolidate show_regs and show_registers for i386
> 
> While I think this is good otherwise, why does it do
> 
> 	printk(".. comm: %.*s .."
> 		TASK_COMM_LEN, current->comm,
> 
> instead of just using "%s" and "current->comm"? I only noticed because 
> there was an unrelated conflict around that thing.
> 
> That "current->comm" had better be NUL-terminated already, we use it as 
> such all over the place. And if it's not, *that* should be fixed.

Fair enough. Did not notice.

     tglx
