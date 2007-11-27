Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbXK0IRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbXK0IRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbXK0IRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:17:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbXK0IRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:17:04 -0500
Date: Tue, 27 Nov 2007 00:17:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 - brick my Dell Latitude D820
Message-Id: <20071127001701.aa3268a7.akpm@linux-foundation.org>
In-Reply-To: <6421.1196150096@turing-police.cc.vt.edu>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4210.1196147786@turing-police.cc.vt.edu>
	<20071126232703.c956addc.akpm@linux-foundation.org>
	<6421.1196150096@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 02:54:56 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Mon, 26 Nov 2007 23:27:03 PST, Andrew Morton said:
> 
> > > git-x86.patch
> > > git-x86-fixup.patch
> > > git-x86-thread_order-borkage.patch
> > > git-x86-thread_order-borkage-fix.patch
> > > git-x86-identify_cpu-fix.patch
> > > git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko.patch
> > > git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko-checkpatch-fixes.patch
> > > git-x86-inlining-borkage.patch
> > > x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
> > > x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch BAD
> 
> > You could try http://userweb.kernel.org/~akpm/mmotm/ - we might have already
> > fixed it.
> 
> I suspect that trying -rc3-mm1 but refreshing just the 10 patches above
> from -mmotm would be far less likely to pull in other heartburn?

All the above are no longer in -mm.  They got merged, dropped,
otherwise-fixed, etc.

> > Otherwise, please proceed to work out which diff I need to drop and hope like
> > hell that it isn't git-x86..
> 
> That's a 41,240 line diff, the rest *total* to about 400 lines.  I don't have
> warm-n-fuzzies about my odds here. ;)

No.

> I'm a git-idiot, but *do* know how to git-bisect through Linus tree - what
> would I need to do to git-bisect through git-x86.patch? (I do *not* know how
> to deal with more than 1 source git tree, so if the magic is just 'get a
> linus tree, merge git-x86, then bisect as usual", I'm stuck on "merge git-x86")..

umm, I'm minimally git-afflicted hence am the wrong person to ask. 
Something like:


- checkout Linus's tree

- echo 'git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git#mm' > .git/branches/git-x86

- git-fetch git-x86

- git-checkout git-x86

- start bisecting.
