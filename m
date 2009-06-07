Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZFGAxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZFGAxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 20:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZFGAxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 20:53:11 -0400
Received: from ozlabs.org ([203.10.76.45]:47733 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbZFGAxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 20:53:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Date: Sun, 7 Jun 2009 10:23:02 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Gerd Knorr <kraxel@suse.de>
References: <4A0B62F7.5030802@goop.org> <200906051416.19311.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906050753550.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906050753550.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906071023.04789.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009 12:24:43 am Linus Torvalds wrote:
> On Fri, 5 Jun 2009, Rusty Russell wrote:
> > Distributions don't ship UP kernels any more; this shows what that costs
> > if you're actually on a UP box.  If we really don't care, perhaps we
> > should make CONFIG_SMP=n an option under EMBEDDED for x86.  And we can
> > rip out the complex patching SMP patching stuff too.
>
> The complex SMP patching is what makes it _possible_ to not ship UP
> kernels any more.

"possible"?  You mean "acceptable".  Gray, not black and white.

1) Where's the line?
2) Where are we?  Does patching claw back 5% of the loss?  50%?  90%?

No point benchmarking on my (SMP) laptop for this one.  Gerd cc'd, maybe he 
has benchmarks from when he did the work originally?

Thanks,
Rusty.
