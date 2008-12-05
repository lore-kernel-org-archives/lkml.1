Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbYLECtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbYLECtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 21:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYLECtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 21:49:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:35155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYLECtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 21:49:03 -0500
Date: Thu, 4 Dec 2008 18:50:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       hpa@zytor.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org
Subject: Re: [patch 2/3] performance counters: documentation
Message-ID: <20081204185002.5faded25@infradead.org>
In-Reply-To: <20081204.163741.48585912.davem@davemloft.net>
References: <20081204225345.654705757@linutronix.de>
	<20081204230228.557959174@linutronix.de>
	<18744.30427.440468.829807@cargo.ozlabs.ibm.com>
	<20081204.163741.48585912.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2008 16:37:41 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Paul Mackerras <paulus@samba.org>
> Date: Fri, 5 Dec 2008 11:33:31 +1100
> 
> > This is going to be a huge problem, at least on powerpc, because it
> > means that the kernel will have to know which events can be counted
> > on which counters and what values need to be put in the control
> > registers to select them.
> 
> Sparc64 is the same.
> 
> > The situation will be even worse with POWER5 and POWER6, where the
> > event selection logic is very complex, with multiple layers of
> > multiplexers.  I really really don't want the kernel to have to know
> > about all that.
> 
> Niagara2 has deep multiplexing and sub-event masking too.
> 
> I really appreciated how perfmon kept all of those details
> in userspace.

I would like to respectfully disagree with this some. The kernel needs
to abstract hardware to some degree for userspace. The problem in this
case is that userspace can't really do a better job, in fact it can
only do a worse job since it lacks the coordination capability of
knowing it has full control of all the hardware registers. 
I am sure the corner cases you're talking about are nasty, I just don't
think they are less nasty when dealt with in userspace. Sure the kernel
might be simpler, but the system as a whole sure is not.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
