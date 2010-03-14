Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0CNJXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 05:23:48 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32774 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0CNJXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 05:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WaDbctw3PcpQSWk4Jm6SXDCQjEzUAK3FfRq9iIaW2K1CxEFN633NB7+SnQEfsutG4B
         R9b8vodDa0ycwtpSci4VKMUSluTJguMwRzunVban8gn47WcYmaQ/yRLa1UaKjxipGGF0
         Bgw5DFZ3icGTQ6JAE9JcB/4/Fr+mngtgoA4bA=
Date: Sun, 14 Mar 2010 10:23:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Also export the weak version of
	perf_arch_fetch_caller_regs
Message-ID: <20100314092341.GA5158@nowhere>
References: <20100312150003.afd9b59a.sfr@canb.auug.org.au> <20100312055043.GB5014@nowhere> <20100312172043.aa034ede.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312172043.aa034ede.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 05:20:43PM +1100, Stephen Rothwell wrote:
> Hi Frederic,
> 
> On Fri, 12 Mar 2010 06:50:44 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > Does that fixes the issue? Sorry I can not test for now...
> 
> I can't test it right now, sorry, but I have heard that EXPORT_SYMBOL's
> for weak symbols must be in a different file from the actual symbol
> definition.



Hmm. Ok, kernel/trace/trace_event_perf.c must be the right place then,
as the only users of this helper are trace events.

Will send a fix once I get this tested, thanks for the pointer!

