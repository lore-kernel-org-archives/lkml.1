Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYJBTE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYJBTE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYJBTEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:04:22 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:54242 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYJBTEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:04:21 -0400
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
References: <20081001223213.078984344@linutronix.de>
	 <1222912413.2995.80.camel@laptop-eth.lan>
	 <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>
	 <1222962525.2995.100.camel@laptop-eth>
	 <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 12:04:14 -0700
Message-Id: <1222974254.2995.144.camel@laptop-eth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-02 at 20:42 +0200, Thomas Gleixner wrote:

> Clearly you have neither clue about real time nor about operating
> systems in general. 

Here we go again Thomas.. You think you can have a conversation without
the insults for once?

> Solaris, some BSDs and MacOSX use interrupt threads. Where exactly is
> the relation to realtime?

The very fact that you mention it in your release notes .. You mention
the type of system in "preempt-rt" and the advantage of your system..

> The concept of interrupt threads is nothing which is in any way
> related to real time. It is a well known and pretty old concept in
> operating system design.
> 
> The fact that real time operating systems benefit from interrupt
> threads is a totally different topic.
> 

The fact that a direct relationship exists means that any threaded
interrupt system needs to take into account the inevitable connection to
real time since it will be used in that system as a core component.. If
you can't effectively achieve real time with your system , than that's a
problem that needs to be addressed. 

Daniel

