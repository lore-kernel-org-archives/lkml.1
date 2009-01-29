Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbZA2OH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbZA2OH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZA2OHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:07:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZA2OHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:07:17 -0500
Date: Thu, 29 Jan 2009 09:07:15 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, npiggin@suse.de,
       torvalds@linux-foundation.org, tglx@linutronix.de, arjan@infradead.org
Subject: Re: [PATCH] use per cpu data for single cpu ipi calls
In-Reply-To: <1233229316.4495.39.camel@laptop>
Message-ID: <alpine.DEB.1.10.0901290906520.13065@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>  <200901290955.38940.rusty@rustcorp.com.au>  <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>  <20090128173039.cbc29e81.akpm@linux-foundation.org>  <1233218954.7835.11.camel@twins>
  <20090129111330.GB30738@elte.hu> <1233229316.4495.39.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 29 Jan 2009, Peter Zijlstra wrote:
> On Thu, 2009-01-29 at 12:13 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > > Can generic_smp_call_function_single_interrupt() ever see 
> > > > CSD_FLAG_ALLOC set now?  If not, that kfree can go away.
> > > 
> > > Like said above, removing that kmalloc will hurt people.
> > 
> > the whole promise of generic-IPI seems to dwindle and we'll get back to 
> > roughly where we started out from.
> 
> I'd not go that far, the per-cpu csd is a nice fallback, but removing
> that kmalloc is just silly.

I'll add the kmalloc back. But the rest should be fine.

-- Steve

