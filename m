Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYHSES4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYHSES4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYHSESs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:18:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:36340 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYHSESs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:18:48 -0400
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Scott Wood <scottwood@freescale.com>, Eran Liberty <liberty@extricom.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com>
	 <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>
	 <48A9AFA7.8080508@freescale.com>
	 <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>
	 <1219110814.8062.2.camel@pasglop>
	 <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>
	 <1219113549.8062.13.camel@pasglop> <1219114600.8062.15.camel@pasglop>
	 <alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 14:17:11 +1000
Message-Id: <1219119431.8062.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 23:12 -0400, Steven Rostedt wrote:
> On Tue, 19 Aug 2008, Benjamin Herrenschmidt wrote:
> 
> > Ok, so i did a patch, but it doesn't fix the problem. So
> > there's something else whacking on the stack frames.
> 
> Is it 32 bit or 64?  I've tested the 64 bit quite a bit, but not so much 
> the 32 (my powerbook is not usually that stable).

32-bit. Reproduced on powerbook by a user, 440, 750, ...

> You might want to look at the entry.S mcount code too.

Yeah, I had a look, nothing obviously bad there, but I may just
have missed it :-)

Ben.


