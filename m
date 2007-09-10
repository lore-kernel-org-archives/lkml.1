Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbXIJPcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbXIJPcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbXIJPby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:31:54 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:53645 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868AbXIJPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:31:53 -0400
Subject: Re: v2.6.23-rc4-rt1 / new project URL
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1189427714.21778.15.camel@twins>
References: <1188593944.9647.15.camel@chaos>
	 <1189427714.21778.15.camel@twins>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 08:18:12 -0700
Message-Id: <1189437492.14752.1.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 14:35 +0200, Peter Zijlstra wrote:

> > - simple_irq change (Kevin Hilman): needs more thought
> > - RCU updates (Paul McKenney): needs proper integration
> > - latency tracer changes (Daniel Walker): needs review
> > - PICK_OP changes (Daniel Walker): needs review
> 
> This one seems to have slipped through the cracks:
>   http://lkml.org/lkml/2007/8/16/135

There was a comment in this patch that reads,

+	/*
+	 * all modifications are done under spinlocks
+	 * but this read is not, the unlock acks as a wmb
+	 * for modifications.
+	 */

I you mean "acts" (like an actor) instead of "acks" here right?

Daniel

