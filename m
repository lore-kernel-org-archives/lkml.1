Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYGNQWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYGNQWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYGNQWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:22:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbYGNQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:22:42 -0400
Date: Mon, 14 Jul 2008 09:22:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] core/softirq for v2.6.27
Message-Id: <20080714092215.0efd7fa3.akpm@linux-foundation.org>
In-Reply-To: <20080714144243.GA21079@elte.hu>
References: <20080714144243.GA21079@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 16:42:43 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>

It would be nice if these short-form summaries were to include the
commit IDs.  eg:

Carlos R. Mafra (1):
      Remove argument from open_softirq which is always NULL (962cf36)

> Carlos R. Mafra (1):
>       Remove argument from open_softirq which is always NULL
> 
> Johannes Berg (1):
>       softirq: remove irqs_disabled warning from local_bh_enable

This doesn't remove the warning?  (Nor should it)

+static inline void _local_bh_enable_ip(unsigned long ip)
 {
+       WARN_ON_ONCE(in_irq() || irqs_disabled());
-       WARN_ON_ONCE(in_irq());
-       WARN_ON_ONCE(irqs_disabled());

It just makes it a bit less useful.
	
> Vegard Nossum (1):
>       softirq: remove initialization of static per-cpu variable
