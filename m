Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZCTHeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZCTHeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 03:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZCTHeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 03:34:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56562 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZCTHd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 03:33:59 -0400
Date: Fri, 20 Mar 2009 13:03:34 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org, systemtap-ml <systemtap@sources.redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip 4/9] power: add kernel_trap_sp()
Message-ID: <20090320073334.GA10519@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49C2B4BF.4080904@redhat.com> <1237527760.25062.567.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237527760.25062.567.camel@pasglop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 04:42:40PM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2009-03-19 at 17:10 -0400, Masami Hiramatsu wrote:
> > Add kernel_trap_sp() on powerpc, based on systemtap's runtime/regs.h.
> > 
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> 
> I haven't looked at the usage of it, but it's weird to have something
> call "kernel_trap_sp" that returns the -user- stack pointer... is
> this really what's expected here ?

In the current usage scenario, this gets called only with a pt_regs
snapshot from in kernel. user_stack_pointer() is a misnomer though;
all this macro needs is to return the stack pointer from the given
pt_regs.

Ananth
