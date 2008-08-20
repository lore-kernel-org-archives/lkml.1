Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYHTVoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYHTVoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYHTVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:44:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61708 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbYHTVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:44:44 -0400
Date: Wed, 20 Aug 2008 17:44:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       Scott Wood <scottwood@freescale.com>,
       Eran Liberty <liberty@extricom.com>, Alan Modra <amodra@au1.ibm.com>,
       Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <1219268189.21386.65.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0808201743560.18551@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>  <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>  <48A9AFA7.8080508@freescale.com>  <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>  <1219110814.8062.2.camel@pasglop>
  <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>  <1219113549.8062.13.camel@pasglop> <1219114600.8062.15.camel@pasglop>  <alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>  <1219119431.8062.35.camel@pasglop> <1219216705.21386.46.camel@pasglop>
  <alpine.DEB.1.10.0808200913070.13132@gandalf.stny.rr.com> <1219268189.21386.65.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Aug 2008, Benjamin Herrenschmidt wrote:

> 
> > > As you can see, it restores r1 -before- it pops r24..r31 off
> > > the stack ! I let you imagine what happens if an interrupt happens
> > > just in between those two instructions (mr and lmw). We don't do
> > > redzones on our ABI, so basically, the registers end up corrupted
> > > by the interrupt.
> > 
> > Ouch!  You've disassembled this without -pg too, and it does not have this 
> > bug? What version of gcc do you have?
> 
> Oops, should have mentioned it ;-)
> 
> 4.2.3 (Ubuntu 4.2.3-2ubuntu7)

I'm running a 4.3.1 (Debian 4.3.1-2) on my powerbook. Perhaps the issue is 
already taken care of.

-- Steve

