Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZCUTG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZCUTG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZCUTGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:06:16 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:43680 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZCUTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:06:16 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090321184904.GA19352@elte.hu>
References: <1235437021.4462.25.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
	 <1235513895.3816.11.camel@localhost.localdomain>
	 <1235595160.9252.49.camel@localhost.localdomain>
	 <1235619922.31774.17.camel@localhost.localdomain>
	 <1236984825.10748.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
	 <1237661053.3196.10.camel@localhost.localdomain>
	 <20090321184904.GA19352@elte.hu>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 12:06:12 -0700
Message-Id: <1237662372.3574.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 19:49 +0100, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > Mar 21 10:47:43 localhost kernel: kernel tried to execute NX-protected
> > page - exploit attempt? (uid: 0)
> > Mar 21 10:47:43 localhost kernel: BUG: unable to handle kernel paging
> > request at f6400800
> 
> kernel tried to execute some really weird address, probably via a 
> function pointer.

Strangely enough rc8-rt1 boots (almost). _Exact_ same build with the
exception of the change from rt1 -> rt2. 

Haldaemon does not start on boot (fails), if I login as root and start
the haldaemon service manually it starts. And then things seem to work
fine (I'm writing this email from that machine). Still investigating...

-- Fernando


> > ehci_hcd [last unloaded: microcode]
> 
> perhaps try excluding the microcode module for now - maybe it messed 
> up something?
> 
> > Mar 21 10:47:43 localhost kernel: EIP: 0060:[<f6400800>] EFLAGS:
> 
> > Mar 21 10:47:43 localhost kernel: Call Trace:
> > Mar 21 10:47:43 localhost kernel: [<f82adb93>] ? iwl3945_irq_tasklet
> > Mar 21 10:47:43 localhost kernel: [<c043d0e2>] ? __tasklet_action
> > Mar 21 10:47:43 localhost kernel: [<c043d1c5>] ? tasklet_action
> > Mar 21 10:47:43 localhost kernel: [<c043ceb7>] ? ksoftirqd+0x131/0x221
> > Mar 21 10:47:43 localhost kernel: [<c043cd86>] ? ksoftirqd+0x0/0x221
> > Mar 21 10:47:43 localhost kernel: [<c0449949>] ? kthread+0x3b/0x61
> > Mar 21 10:47:43 localhost kernel: [<c044990e>] ? kthread+0x0/0x61
> > Mar 21 10:47:43 localhost kernel: [<c0409207>] ? kernel_thread_helper
> 
> does any of the Fedora patches you have applied involve wireless 
> changes? I'd suggest undoing those first.


