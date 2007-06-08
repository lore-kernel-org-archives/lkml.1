Return-Path: <linux-kernel-owner+w=401wt.eu-S967380AbXFHCaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967380AbXFHCaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966489AbXFHCa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:30:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965718AbXFHCaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:30:24 -0400
Date: Thu, 7 Jun 2007 19:29:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] enable interrupts in user path of page fault.
In-Reply-To: <1181268406.10408.26.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0706071928140.4205@woody.linux-foundation.org>
References: <1181187244.18444.45.camel@localhost.localdomain> 
 <20070607185851.faf36f95.akpm@linux-foundation.org>
 <1181268406.10408.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Steven Rostedt wrote:
> 
> I didn't realize that userspace was allowed to run with interrupts
> disabled.

It isn't, normally. You *can* try to do it by using iopl(), but it's not 
practical. It's certainly not practical to expect a page fault to not 
enable them again, since we obviously need interrupts enabled just to 
handle any IO. 

So don't worry about it. 

		Linus
