Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbYHSVs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbYHSVs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYHSVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:48:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:49014 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758536AbYHSVso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:48:44 -0400
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Scott Wood <scottwood@freescale.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20080819173453.GA28239@Krystal>
References: <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>
	 <48A9AFA7.8080508@freescale.com>
	 <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
	 <1219110814.8062.2.camel@pasglop>
	 <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>
	 <1219113549.8062.13.camel@pasglop>
	 <alpine.DEB.1.10.0808182240330.13401@gandalf.stny.rr.com>
	 <20080819024707.GA22659@Krystal>
	 <alpine.DEB.1.10.0808191247001.28232@gandalf.stny.rr.com>
	 <20080819173453.GA28239@Krystal>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 07:47:51 +1000
Message-Id: <1219182471.7826.16.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Ok, there are two cases where it's ok :
> 
> 1 - in stop_machine, considering we are not touching code executed in
> NMI handlers.
> 2 - when using my replace_instruction_safe() which uses a temporary
> breakpoint when doing the instruction replacement.
> 
> In those cases you could use text_poke_early().

Note that vmap/vunmap will be very slow.

Ben.


