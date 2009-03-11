Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZCKPlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZCKPlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZCKPl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:41:27 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35578 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbZCKPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:41:27 -0400
Subject: Re: [PATCH 00/13] convert voyager over to the x86 quirks model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <20090310223733.GA4016@elte.hu>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <20090310223733.GA4016@elte.hu>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 10:41:22 -0500
Message-Id: <1236786082.3270.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 23:37 +0100, Ingo Molnar wrote: 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > Given the lack of feedback, I went ahead and implemented the 
> > additions to smp_ops and x86_quirks (and a dynamic mca NMI 
> > hook) to allow voyager to be plumbed in.
> > 
> > There also needs to be changes in the boot setup to make 
> > voyager work dynamically: It has to be detected first, so the 
> > a20 gate check is only executed if a voyager is not found.
> > 
> > I also completed some of the subarchitecture eliminations, so 
> > all the include file infrastructure should be gone.
> > 
> > The result is that I can boot both my PC SMP x86 boxes and 
> > voyager with the same kernel.
> > 
> > This patch series applies on the x86/apic branch of the x86 
> > tree (obviously with 965c7ecaf2e2b083d711a01ab33735a4bdeee1a4 
> > reverted)
> 
> The question is, why would we want to merge Voyager back ever 
> again?

What do you mean merge back?  It's an existing and supported
architecture in git head.

> The hardware is obsolete and is not being produced anymore,

That goes for a huge number of drivers we have in the kernel currently,
and several whole architectures, so it's not a barrier to keeping
something maintained.

> nobody but you uses development kernels on it,

I don't think we've ever had a problem with a downstream community being
supported by a single upstream developer.

>  and it caused all 
> sorts of x86 maintenance overhead all along. It did not even 
> build since August 2008, up until the point we removed it - 
> 2.6.26.0 was the last time it built.

2.6.29-rc7 builds and boots just fine from git head.

Your prior statement was that you wanted it moved to the x86 quirks
infrastructure to make it easily maintainable, which this patch series
does ... I don't quite see what your problem is now ... are you saying
that x86 quirks isn't as maintainable as you previously thought?  In
which case, how can I help?

James


