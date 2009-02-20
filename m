Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZBTWsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZBTWsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZBTWsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:48:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZBTWsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:48:33 -0500
Subject: Re: [announce] Performance Counters for Linux, v6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <499F30F4.509@linux.vnet.ibm.com>
References: <20090121185021.GA8852@elte.hu>
	 <499DD4BE.2000704@linux.vnet.ibm.com> <20090220081040.GA11490@elte.hu>
	 <499F30F4.509@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 23:47:58 +0100
Message-Id: <1235170078.4736.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 14:38 -0800, Corey Ashford wrote:
> There may be other non-event-related changes that will not be handled 
> quite as well in this way.  In the original email I hinted at that we 
> may want an option for mmap'd sample buffers at some point, and so I'm 
> not clear how you'd provide an ABI to request mmap'd buffers (you would 
> probably need to be able to request the size and get back a pointer to 
> the mmap'd buffer).  Would this be done through a special 
> sys_perf_counter_open call?  Or through a subsequent ioctl call on the 
> group leader after an open (which requires the counters to be initially 
> disabled), etc.

What's stopping a regular mmap() call using the fd obtained from
sys_perf_counter_open() ?



