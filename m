Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZCTKdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZCTKdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZCTKcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:32:54 -0400
Received: from www.tglx.de ([62.245.132.106]:59406 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZCTKcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:32:54 -0400
Date: Fri, 20 Mar 2009 11:31:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
In-Reply-To: <20090320092234.GA3792@elte.hu>
Message-ID: <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <20090320092234.GA3792@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Ingo Molnar wrote:
> > ---
> >  scripts/Kbuild.include |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Doesnt fully work:
> 
> arch/x86/kernel/entry_32.S:346: Error: unknown pseudo-op: `.cfi_signal_frame'
> arch/x86/kernel/entry_32.S:394: Error: unknown pseudo-op: `.cfi_signal_frame'
> arch/x86/kernel/entry_32.S:519: Error: unknown pseudo-op: `.cfi_signal_frame'
> arch/x86/kernel/entry_32.S:614: Error: unknown pseudo-op: `.cfi_signal_frame'
> arch/x86/kernel/entry_32.S:685: Error: unknown pseudo-op: `.cfi_signal_frame'
> arch/x86/kernel/entry_32.S:754: Error: unknown pseudo-op: `.cfi_signal_frame'
> 
> config attached. Distcc driven build.

Same config works fine here. Do you have different compilers/binutils
on your distcc cluster ? I tripped over this distcc feature in the
past, that's why I have switched to iceccc.

       tglx
