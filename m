Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbXIJQPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbXIJQPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933031AbXIJQPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:15:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35709 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbXIJQPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:15:21 -0400
Subject: Re: v2.6.23-rc4-rt1 / new project URL
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1189437492.14752.1.camel@imap.mvista.com>
References: <1188593944.9647.15.camel@chaos>
	 <1189427714.21778.15.camel@twins>
	 <1189437492.14752.1.camel@imap.mvista.com>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 18:15:02 +0200
Message-Id: <1189440902.21778.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 08:18 -0700, Daniel Walker wrote:
> On Mon, 2007-09-10 at 14:35 +0200, Peter Zijlstra wrote:
> 
> > > - simple_irq change (Kevin Hilman): needs more thought
> > > - RCU updates (Paul McKenney): needs proper integration
> > > - latency tracer changes (Daniel Walker): needs review
> > > - PICK_OP changes (Daniel Walker): needs review
> > 
> > This one seems to have slipped through the cracks:
> >   http://lkml.org/lkml/2007/8/16/135
> 
> There was a comment in this patch that reads,
> 
> +	/*
> +	 * all modifications are done under spinlocks
> +	 * but this read is not, the unlock acks as a wmb
> +	 * for modifications.
> +	 */
> 
> I you mean "acts" (like an actor) instead of "acks" here right?

ah, indeed :-) sometimes my fingers have a life of their own.

