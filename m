Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZFDVxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZFDVxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZFDVxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:53:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39939 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZFDVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:53:05 -0400
From: Dave McCracken <dcm@mccr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Date: Thu, 4 Jun 2009 16:52:54 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28; KDE/4.2.2; x86_64; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Message-Id: <200906041652.55298.dcm@mccr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Linus Torvalds wrote:
> On Thu, 4 Jun 2009, Rusty Russell wrote:
> > > Turn off HIGHMEM64G, please (and HIGHMEM4G too, for that matter - you
> > > can't compare it to a no-highmem case).
> >
> > Thanks, your point is demonstrated below.  I don't think HIGHMEM4G is
> > unreasonable for a distro tho, so I turned that on instead.
>
> Well, I agree that HIGHMEM4G is a reasonable thing to turn on.
>
> The thing I disagree with is that it's at all valid to then compare to
> some all-software feature thing. HIGHMEM doesn't expand any esoteric
> capability that some people might use - it's about regular RAM for regular
> users.

I think you're missing the point of Rusty's benchmark.  I see his exercise as 
"compare a kernel configured as a distro would vs a custom-built kernel 
configured for the exact target environment".  In that light, questions about 
the CONFIG options Rusty used should be based on whether most distros would 
use them in their stock kernels as opposed to how necessary they are.

What I see as the message of his benchmark is if you care about performance 
you should be customizing your kernel anyway.  Distro kernels are slow.  An 
option that makes the distro kernel a bit slower is no big deal since anyone 
who wants speed should already be rebuilding their kernel.

Don't get me wrong.  I think it's always a good idea to minimize any 
performance penalty, even under specific configurations.  I just think 
criticizing it because distros might enable it is a poor argument.

Dave McCracken
Oracle Corp.

