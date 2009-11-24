Return-Path: <linux-kernel-owner+w=401wt.eu-S933975AbZKXTDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbZKXTDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933903AbZKXTDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:03:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:48713 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933872AbZKXTDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:03:02 -0500
Message-ID: <4B0C2D11.80008@kernel.org>
Date: Tue, 24 Nov 2009 10:59:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Len Brown <lenb@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
References: <20091120211139.GB19106@sgi.com>	 <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com>	 <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>	 <1259069986.4531.1453.camel@laptop>	 <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>	 <20091124065022.6933be1a@infradead.org> <m1ws1f6csh.fsf@fess.ebiederm.org>	 <20091124182059.GB11894@elte.hu>  <4B0C259A.5020303@kernel.org> <1259087563.4531.1776.camel@laptop>
In-Reply-To: <1259087563.4531.1776.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-11-24 at 10:27 -0800, Yinghai Lu wrote:
> 
>> we already have dev numa node, so could just make irqblance to some smart to use
>> that device node corresponding for irq that is binding to the device.
> 
> The argument is that a single device can have multiple IRQs and
> therefore numa nodes.

one node could have 8 cores or 16 threads, so should be right.

other case the intel new 4 sockets system will have two IOHs, and one for socket0 and socket 1
and one for socket2 and socet3

acpi root bus _PXM only can return one.
so wonder if ACPI spec need to be extended to support two nodes there.

after that, we need to extend numa_node to support that.

YH
