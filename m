Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbYHOP0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbYHOP0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYHOP0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:26:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49670 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYHOP0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:26:33 -0400
Date: Fri, 15 Aug 2008 17:25:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, mingo@redhat.com, linux-kernel@vger.kernel.org, ak@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: remove empty lines from stack traces/oopses
Message-ID: <20080815152555.GJ10029@elte.hu>
References: <20080731235137.GA4816@martell.zuzino.mipt.ru> <20080811170219.GJ4524@elte.hu> <20080811192210.GA5791@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811192210.GA5791@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Aug 11, 2008 at 07:02:19PM +0200, Ingo Molnar wrote:
> > * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > >  show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
> > >  		unsigned long *stack, unsigned long bp, char *log_lvl)
> > >  {
> > > -	printk("\nCall Trace:\n");
> > > +	printk("Call Trace:\n");
> > >  	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
> > > -	printk("\n");
> > >  }
> > 
> > hm, it's nice to have stack traces stand out a bit, and to not get the 
> > 'Call Trace' embedded in the middle of a printk (which happens to crash 
> > or produce a stack dump).
> 
> Sometimes all you have is 80x25 or just screenshot from some stupid windows
> monitoring program.

> > just to make sure i get the gist of your change, do you have a 
> > 'before' and 'after' sample oops, so that we can see the difference?
> 
> Any recent oops with and without empty lines after Call trace: and 
> after calltrace.

ok - i've queued up your fix in tip/x86/debug.

Arjan, can the removal of empty newlines break the kerneloops.org 
parser?

	Ingo
