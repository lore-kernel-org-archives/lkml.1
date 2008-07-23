Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYGWJyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYGWJyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYGWJyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:54:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46286 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYGWJyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:54:43 -0400
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
In-Reply-To: <4886FA97.40104@qumranet.com>
References: <20080717155724.897537670@polymtl.ca>
	 <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com>
	 <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com>
	 <48862B01.7070907@qumranet.com> <1216799346.7257.125.camel@twins>
	 <4886E6FD.4090200@qumranet.com> <1216803303.7257.138.camel@twins>
	 <4886FA97.40104@qumranet.com>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 11:53:54 +0200
Message-Id: <1216806834.7257.156.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 12:32 +0300, Avi Kivity wrote:
> Peter Zijlstra wrote:
> > There are currently no trace_mark() sites in the kernel that I'm aware
> > of (except for the scheduler :-/, and those should be converted to
> > tracepoints ASAP).
> >
> > Andrew raised the whole point about trace_mark() generating an
> > user-visible interface and thus it should be stable, and I agree with
> > that.
> >
> > What that means is that trace_mark() can only be used for really stable
> > points.
> >
> > This in turn means we might as well use trace points.
> >
> > Which allows for the conclusion that trace_mark() is not needed and
> > could be removed from the kernel.
> >
> > However - it might be handy for ad-hoc debugging purposes that never see
> > the light of day (linus' git tree in this case). So on those grounds one
> > could argue against removing trace_mark
> 
> But trace_mark() is so wonderful.

I guess tastes differ...

>   Can't we just declare the tracemarks 
> as a non-stable interface?
> 
> Perhaps add an unstable_trace_mark() to make it clear.

At the very least it would need its own output channel. But I'm afraid
this will be KS material.

