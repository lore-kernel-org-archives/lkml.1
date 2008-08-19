Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYHSB5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYHSB5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYHSB5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:57:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:60434 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbYHSB5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:57:42 -0400
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Eran Liberty <liberty@extricom.com>, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org
In-Reply-To: <20080818184158.GA1798@Krystal>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>
	 <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com>
	 <20080818184158.GA1798@Krystal>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 11:54:08 +1000
Message-Id: <1219110848.8062.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Oops: Exception in kernel mode, sig: 11 [#1]
> > Exsw1600
> > Modules linked in:
> > NIP: c00bbb20 LR: c00bbb20 CTR: 00000000
> > REGS: dd5b1c50 TRAP: 0700   Not tainted  (2.6.27-rc2)
> > MSR: 00029000 <EE,ME>  CR: 24082282  XER: 20000000
> > TASK = ddcce060[1707] 'find' THREAD: dd5b0000
> > GPR00: 00000000 dd5b1d00 ddcce060 dd801180 dd5b1d68 dd5b1d58 dd80125b 
> > 100234ec
> > GPR08: c0800000 00019330 0000ffff dd5b1d20 24000288 100ad874 100936f8 
> > 1008a1d0
> > GPR16: 10083f80 dd5b1e2c dd5b1d68 fffffff4 c0380000 dd5b1d60 dd5b1d58 
> > dd802084
> > GPR24: dc3d7700 dd802018 dd5b1d68 c0380000 dd801180 dd5b1d68 00000000 
> > dd5b1d00
> > NIP [c00bbb20] d_lookup+0x40/0x90
> > LR [c00bbb20] d_lookup+0x40/0x90
> > Call Trace:
> > [dd5b1d00] [dd5b1d58] 0xdd5b1d58 (unreliable)
> 
> Can you check if, at some point during the system execution (starting
> from boot), 0xdd5b1d58 is an address where a module is loaded ? (the
> module can be later unloaded, what I wonder is if this address would
> appear to have had a loaded+unloaded module).
> 
> Actually, could you try to compile your kernel without "MODULE_UNLOAD" ?

I've had similar crashes (with similar backtraces in the VFS) on
machines with no modules, netbooted zImages.

Ben.


