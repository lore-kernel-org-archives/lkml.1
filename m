Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYBAQWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYBAQWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYBAQV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:21:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57897 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbYBAQVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:21:55 -0500
Date: Fri, 1 Feb 2008 17:21:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] X86: Fix trailing statements should be on next line
Message-ID: <20080201162139.GC15156@elte.hu>
References: <20080129000744.698639d3@paolo-desktop> <20080128230746.GL8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128230746.GL8953@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Willy Tarreau <w@1wt.eu> wrote:

> Hi Paolo,
> 
> On Tue, Jan 29, 2008 at 12:07:44AM +0100, Paolo Ciarrocchi wrote:
> > Fix trailing statements should be on next line
> 
> > -if ( partial_status & SW_C3 )          printk("SW: condition bit 3\n");
> > -if ( partial_status & SW_C2 )          printk("SW: condition bit 2\n");
> > -if ( partial_status & SW_C1 )          printk("SW: condition bit 1\n");
> > -if ( partial_status & SW_C0 )          printk("SW: condition bit 0\n");
> > -if ( partial_status & SW_Summary )     printk("SW: exception summary\n");
> > -if ( partial_status & SW_Stack_Fault ) printk("SW: stack fault\n");
> > -if ( partial_status & SW_Precision )   printk("SW: loss of precision\n");
> > -if ( partial_status & SW_Underflow )   printk("SW: underflow\n");
> > -if ( partial_status & SW_Overflow )    printk("SW: overflow\n");
> > -if ( partial_status & SW_Zero_Div )    printk("SW: divide by zero\n");
> > -if ( partial_status & SW_Denorm_Op )   printk("SW: denormalized operand\n");
> > -if ( partial_status & SW_Invalid )     printk("SW: invalid operation\n");
> 
> > +if ( partial_status & SW_Backward )
> > +printk("SW: backward compatibility\n");
> > +if ( partial_status & SW_C3 )
> > +printk("SW: condition bit 3\n");
> > +if ( partial_status & SW_C2 )
> > +printk("SW: condition bit 2\n");
> > +if ( partial_status & SW_C1 )
> > +printk("SW: condition bit 1\n");
> > +if ( partial_status & SW_C0 )
> > +printk("SW: condition bit 0\n");
> > +if ( partial_status & SW_Summary )
> > +printk("SW: exception summary\n");
> > +if ( partial_status & SW_Stack_Fault )
> > +printk("SW: stack fault\n");
> > +if ( partial_status & SW_Precision )
> > +printk("SW: loss of precision\n");
> > +if ( partial_status & SW_Underflow )
> > +printk("SW: underflow\n");
> > +if ( partial_status & SW_Overflow )
> > +printk("SW: overflow\n");
> > +if ( partial_status & SW_Zero_Div )
> > +printk("SW: divide by zero\n");
> > +if ( partial_status & SW_Denorm_Op )
> > +printk("SW: denormalized operand\n");
> > +if ( partial_status & SW_Invalid )
> > +printk("SW: invalid operation\n");
> >  #endif /* DEBUGGING */
> 
> Well, IMHO, the code was more readable and checkable in the initial 
> version. I think this is one example of exceptions where code 
> appearance is more important than style correctness.

definitely so. The rule of thumb is: if in doubt, use your human taste. 
Does it 'look' better? If not, dont do the change.

	Ingo
