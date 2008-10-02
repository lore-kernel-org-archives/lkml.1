Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYJBNBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYJBNBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYJBNBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:01:06 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17686 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbYJBNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:01:04 -0400
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <20081001223213.078984344@linutronix.de>
References: <20081001223213.078984344@linutronix.de>
Content-Type: text/plain
Date: Wed, 01 Oct 2008 18:53:33 -0700
Message-Id: <1222912413.2995.80.camel@laptop-eth.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 23:02 +0000, Thomas Gleixner wrote:
> The implementation provides an opt-in mechanism to convert drivers to
> the threaded interrupt handler model contrary to the preempt-rt patch
> where the threaded handlers are enabled by a brute force switch. The
> brute force switch is suboptimal as it does not change the interrupt
> handler -> tasklet/softirq interaction problems, but was the only way
> which was possible for the limited man power of the preempt-rt
> developers.
> 
> Converting an interrupt to threaded makes only sense when the handler
> code takes advantage of it by integrating tasklet/softirq
> functionality and simplifying the locking.

I'm not clear on your direction here.. I don't have a problem with a
mass driver audit, which I think is what your suggesting with this patch
set .. However, a mass audit like that would push a fully real time
system out for quite some time..

I also don't see a clear connection between these changes and ultimately
removing spinlock level latency in the kernel. I realize you don't
address that in your comments, but this is part of the initiative to
remove spinlock level latency..

So with this set of changes and in terms of real time, I'm wonder your
going with this ?

Daniel

