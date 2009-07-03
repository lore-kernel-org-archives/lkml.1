Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZGCKnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZGCKnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZGCKnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:43:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59774 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751584AbZGCKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:43:12 -0400
Date: Fri, 3 Jul 2009 11:44:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703114431.37abd528@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703102234.GA32128@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
	<20090703064518.GA30674@elte.hu>
	<20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
	<20090703091655.GB3902@elte.hu>
	<20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
	<20090703095432.GC21141@elte.hu>
	<20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	<20090703102234.GA32128@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Which is a cut and paste of code from the originals into the 
> > helper.
> 
> and this changes my points how? It's not like it's hard to fix, and 
> the code is moved non-trivially anyway, it's better to have it nicer 
> if we touch it anyway.

Its called engineering and good practice. The old code was correct. The
paste of it is therefore most likely to be correct. Furthermore patches
shouldn't mix clean up with other changes. So doing it as one is most
definitely bad practice.

> > > Also note the inconsistent printk-ing lines, mutiliated by line 
> > > warps. The use of pr_warning() would solve it:
> > 
> > Send patches if it bugs you that much. [...]
> 
> I find that a rather flippant attitude to kernel code quality 
> issues.

I have better uses for my time than fiddling with pr_warning(). Fixing
real bugs for example, bugs that crash your system, broken locking that
goes back to Linux 2.2 and DaveM's original push of lock_kernel out of
IRQ paths

> Also, isnt it a double standard: why should newbies be held to 
> higher standards than you hold yourself to?

Why should anyone be held up to bogus standards ?

To bend an appropriate metaphor Ingo - you are trying to criticize the
paint finish of the bike shed while some of us are still replacing the
rusted and corroded beams.

If it was a new bike shed you might be in order, but at the moment the
tty layer is rescue archaeology and I'm spending my time doing useful
things like fixing the real bugs and getting from where we are now to
somewhere useful without causing too much carnage on the way. pr_warning
is an end of the journey polishing job.

The x86 experience doesn't translate here - Andi left you a well
maintained, well polished starting point. Nobody has been maintaining tty
for years.

Alan
