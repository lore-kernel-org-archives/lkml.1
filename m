Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYKSMPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYKSMPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYKSMPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:15:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYKSMPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:15:23 -0500
Date: Wed, 19 Nov 2008 07:15:21 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
In-Reply-To: <alpine.DEB.1.10.0811190650460.20272@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811190714340.20272@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <18720.42209.880409.297291@cargo.ozlabs.ibm.com> <alpine.DEB.1.10.0811171035530.2919@gandalf.stny.rr.com> <alpine.DEB.1.10.0811180853390.15003@gandalf.stny.rr.com> <18723.31762.522696.647294@cargo.ozlabs.ibm.com>
 <alpine.DEB.1.10.0811182150530.14914@gandalf.stny.rr.com> <20081119092723.GC22309@elte.hu> <18723.60578.179210.736789@cargo.ozlabs.ibm.com> <20081119105719.GA21533@elte.hu> <alpine.DEB.1.10.0811190650460.20272@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008, Steven Rostedt wrote:

> 
> On Wed, 19 Nov 2008, Ingo Molnar wrote:
> > 
> > Maybe Steve could do the following trick: create a Linus -git based 
> > branch that uses the new APIs but marks ppc's ftrace as "depends 0" in 
> > the powerpc Kconfig. (the new ftrace.c wont build)
> 
> There's only two generic commits that need to be added for the PowerPC 
> code to work.
> 
>   ftrace: pass module struct to arch dynamic ftrace functions
>   ftrace: allow NULL pointers in mcount_loc
> 
> I've already ported them to mainline to test PowerPC there.
> Paul could use these two versions and keep ftrace in a separate branch in 
> his tree. This way all the PowerPC code will be there, and actually can be 
> tested. They may still hit the same bugs that we have fixed in tip, but 
> those should all be minor, since any major bug is already in mainline or 
> on its way.

I just pushed all the PowerPC patches on top of this port it works.
I still need to rework the patches for Paul.

-- Steve

