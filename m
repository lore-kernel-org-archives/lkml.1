Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbZB0PG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbZB0PG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZB0PGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:06:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:44599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZB0PGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:06:18 -0500
Date: Fri, 27 Feb 2009 07:06:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
Message-ID: <20090227070633.2c3fc04e@infradead.org>
In-Reply-To: <1235721910.4948.1321.camel@laptop>
References: <20090226131336.423054348@linutronix.de>
	<20090226131719.760899560@linutronix.de>
	<20090226153216.5db66bc3.akpm@linux-foundation.org>
	<20090226212752.332ba546@infradead.org>
	<20090226214514.f8a58731.akpm@linux-foundation.org>
	<1235719113.4948.1252.camel@laptop>
	<20090226234800.4977fca5.akpm@linux-foundation.org>
	<1235721910.4948.1321.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 09:05:10 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> 
> Right, Thomas did the EHCI usb driver, the network driver you propose
> is a tad hard since it relies on the whole network stack softirq
> stuff. Re-working the whole net-stack to make use of threaded
> handlers is a massive undertaking -- although I seem to remember
> someone doing it a few years back and seeing a general performance
> improvement, Thomas still got a link to that work?


we shouldn't have to; just running the softirq handler from the irq
thread should work, and not lose real performance.
Sure you're not going to get a performance gain that you could get
but it still works.
or am I missing something?

(and esp for things like wireless drivers, that should be just fine; I
can understand hesitation to do 10g ethernet drivers right away ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
