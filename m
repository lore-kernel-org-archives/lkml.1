Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbXEURMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbXEURMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbXEURML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:12:11 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34201 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbXEURMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:12:10 -0400
Date: Mon, 21 May 2007 10:08:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Stable Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [stable] [PATCH] Ignore bogus ACPI info for offline CPUs
Message-ID: <20070521170815.GE3429@sequoia.sous-sol.org>
References: <1179584570.12981.123.camel@chaos> <200705210947.35350.dvhltc@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705210947.35350.dvhltc@us.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Darren Hart (dvhltc@us.ibm.com) wrote:
> On Saturday 19 May 2007 07:22:50 Thomas Gleixner wrote:
> > Booting a SMP kernel with maxcpus=1 on a SMP system leads to a hard
> > hang, because ACPI ignores the maxcpus setting and sends timer broadcast
> > info for the offline CPUs. This results in a stuck for ever call to
> > smp_call_function_single() on an offline CPU.
> >
> > Ignore the bogus information and print a kernel error to remind ACPI
> > folks to fix it.
> >
> > Affects 2.6.21 / 2.6.22-rc
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> When I first booted with this patch I received the following in a loop:
> 
> irq 9: nobody cared (try booting with the "irqpoll" option)

What happens when booting w/out this patch?  Don't want to add known
regression to -stable.

thanks,
-chris
