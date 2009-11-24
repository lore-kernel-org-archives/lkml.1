Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbZKXOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbZKXOs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932972AbZKXOsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:48:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:55275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbZKXOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:48:55 -0500
Date: Tue, 24 Nov 2009 06:50:22 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Dimitri Sivanich <sivanich@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091124065022.6933be1a@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
References: <20091120211139.GB19106@sgi.com>
	<m1r5rrr9v5.fsf@fess.ebiederm.org>
	<20091122011457.GA16910@sgi.com>
	<alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
	<1259069986.4531.1453.camel@laptop>
	<alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 14:55:15 +0100 (CET)
> > Furthermore, the /sysfs topology information should include IRQ
> > routing data in this case.
> 
> Hmm, not sure about that. You'd need to scan through all the nodes to
> find the set of CPUs where an irq can be routed to. I prefer to have
> the information exposed by the irq enumeration (which is currently in
> /proc/irq though).

yes please.

one device can have multiple irqs
one irq can be servicing multiple devices

expressing that in sysfs is a nightmare, while
sticking it in /proc/irq *where the rest of the info is* is
much nicer for apps like irqbalance


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
