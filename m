Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZFEEqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZFEEqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZFEEqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:46:21 -0400
Received: from ozlabs.org ([203.10.76.45]:35574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbZFEEqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:46:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Date: Fri, 5 Jun 2009 14:16:18 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <4A0B62F7.5030802@goop.org> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051416.19311.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 12:32:14 am Linus Torvalds wrote:
> So I think your minimum and maximum configs should at least _match_ in
> HIGHMEM. Limiting memory to not actually having any (with "mem=880M") will
> avoid the TLB flushing impact of HIGHMEM, which is clearly going to be the
> _bulk_ of the overhead, but HIGHMEM is still going to be noticeable on at
> least some microbenchmarks.

Well, Ingo was ranting because (paraphrase) "no other config option when 
*unused* has as much impact as CONFIG_PARAVIRT!!!!!!!!!!".

That was the point of my mail; facts show it's simply untrue.

> The comparison is ugly and pointless.
(Re: SMP)

Distributions don't ship UP kernels any more; this shows what that costs if 
you're actually on a UP box.  If we really don't care, perhaps we should make 
CONFIG_SMP=n an option under EMBEDDED for x86.  And we can rip out the complex 
patching SMP patching stuff too.

> Something like CONFIG_HIGHMEM* or CONFIG_SMP is not really what I'd ever
> call "optional feature", although I hope to Dog that CONFIG_HIGHMEM can
> some day be considered that some day.

Someone from a distro might know how many deployed machines don't need them.  
Kernel hackers tend to have modern machines; same with "enterprise" sites.  I 
have no idea.

Without those facts, I'll leave further discussion to someone else :)

Thanks,
Rusty.
