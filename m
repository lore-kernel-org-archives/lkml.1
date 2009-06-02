Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZFBO5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZFBO5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZFBO5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:57:05 -0400
Received: from mail-qy0-f104.google.com ([209.85.221.104]:61252 "EHLO
	mail-qy0-f104.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZFBO5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:57:04 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 10:57:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=EqnzxenEe1HG9giKi5TKDdxtXnIE05z+g2RjYYCIq1+8TyPznugEdRYQ9FByL7WLdP
         TM0H/idyhw72W0L9kYJwivrwaYrFgm45r9RooeUJ9gQcMD2Pm+ZoxXr7+hCumkiBm5KB
         CYA0iJLvP4+ys8VY/ylV8vTloKtqhVHGBZq6M=
MIME-Version: 1.0
In-Reply-To: <20090602141802.GC3914@think>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu>
	 <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de>
	 <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think>
Date: Tue, 2 Jun 2009 07:49:32 -0700
Message-ID: <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native 
	kernels
From: Ulrich Drepper <drepper@gmail.com>
To: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 7:18 AM, Chris Mason <chris.mason@oracle.com> wrote:
> I'm not suggesting we should take broken code, or that we should lower
> standards just for xen.  But, expecting the xen developers to fix the 1%
> hit on a very specific micro-benchmark is not a way to promote new
> projects for the kernel, and it isn't a good way to convince people to
> do continued development in mainline instead of in private trees.

It's not a new project which needs to be treated with kid's gloves.
And one be sure that once the code is in the tree those interested
parties will not be as strongly motivated to fix any problem like
this.  Ingo pointed to a way which doesn't negatively impact the
performance of the Xen kernel and reduces the overhead (dynamic
patching).  Just get started on this (and general cleanup) and this
whole argument will go away.

I find it ridiculous to use the "but it's used" argument to try to
force the code into the kernel.  By this argument you can say the same
about crap like ndiswrapper and similarly harmful code.
