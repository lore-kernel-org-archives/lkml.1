Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZFEObv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZFEObv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZFEObo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:31:44 -0400
Received: from ozlabs.org ([203.10.76.45]:55258 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbZFEObn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:31:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Date: Sat, 6 Jun 2009 00:01:36 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Dave McCracken <dcm@mccr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <4A0B62F7.5030802@goop.org> <200906041652.55298.dcm@mccr.org> <4A28C9CD.2010208@redhat.com>
In-Reply-To: <4A28C9CD.2010208@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906060001.38069.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 05:01:25 pm Gerd Hoffmann wrote:
>    Hi,
>
> > I think you're missing the point of Rusty's benchmark.  I see his
> > exercise as "compare a kernel configured as a distro would vs a
> > custom-built kernel configured for the exact target environment".  In
> > that light, questions about the CONFIG options Rusty used should be based
> > on whether most distros would use them in their stock kernels as opposed
> > to how necessary they are.
>
> Well.  The test ran on a machine with so much memory that you need
> HIGHMEM to use it all.  I think it also was SMP.  So a custom kernel for
> *that* machine would certainly include SMP and HIGHMEM ...

I have a UP machine with 512M of RAM, but I wasn't going to take it out just 
to prove the point.  Hence I used my test machine with mem=880 maxcpus=1 to 
simulate it, but that's a distraction here.

> While it might be
> interesting by itself to see what the overhead of these config options
> is, it is IMHO quite pointless *in the context of this discussion*.

No, you completely missed the point.
Rusty.
