Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZELOnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZELOnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZELOn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:43:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbZELOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:43:25 -0400
Date: Tue, 12 May 2009 07:36:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Robin Holt <holt@sgi.com>
cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, systemtap@sources.redhat.com,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jan Blunck <jblunck@suse.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -rc] [BUGFIX] x86: fix kernel_trap_sp()
In-Reply-To: <20090512112300.GL7601@sgi.com>
Message-ID: <alpine.LFD.2.01.0905120732580.3586@localhost.localdomain>
References: <20090511210300.17332.67549.stgit@localhost.localdomain> <alpine.LFD.2.01.0905111512240.3586@localhost.localdomain> <20090512112300.GL7601@sgi.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 May 2009, Robin Holt wrote:
> >   */
> > -static inline unsigned long kernel_trap_sp(struct pt_regs *regs)
> > +static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> 
> Why not have it return an unsigned long *?

I considered it, but since part of the point of the patch was to make it 
look like the mirror of "user_stack_pointer()", returning "unsigned long" 
looked more appropriate.

But I have no really strong opinions. I wouldn't object to making it 
return "unsigned long *" either.

		Linus
