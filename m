Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbXEBHsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbXEBHsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXEBHsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:48:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbXEBHsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:48:40 -0400
Date: Wed, 2 May 2007 00:48:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work
 as expected (2nd try)
Message-Id: <20070502004824.9f9cbdfe.akpm@linux-foundation.org>
In-Reply-To: <200705020917.00134.juergen127@kreuzholzen.de>
References: <200704301409.l3UE9sFg019392@harpo.it.uu.se>
	<200704301733.41903.juergen127@kreuzholzen.de>
	<20070501174808.4ac5378b.akpm@linux-foundation.org>
	<200705020917.00134.juergen127@kreuzholzen.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 09:16:59 +0200 Juergen Beisert <juergen127@kreuzholzen.de> wrote:

> >
> > This clashes with Andi's "msr-index" patch:
> >
> > ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/msr-index
> 
> I see. He also moves these defines to another file. Not problem where they 
> are. But it isn't possible to replace the macros by the inlined functions in 
> processor.h. The used outb/inb macros fail for various other files.

Oh well.  Please work out what you think needs to be done.

> > Perhaps it'd be best to wait until msr-index goes upstream and to raise a
> > patch then.  Or to redo and retest against 2.6.21-rc7-mm2, which includes
> > msr-index.
> 
> All right. To wait is no problem for me (my system works with my 
> patch.... ;-) )
> 
> > Also, include/asm-x86_64/processor.h has a getCx86(), too.  Does it also
> > need fixing?
> 
> As I can see the macros are used in:
>  - i386/kernel/cpu/cpufreq/gx-suspmod.c (ups, its not in my patch, so it is
>    currently no complete)
>  - i386/kernel/cpu/mtrr/state.c (also not part of my patch yet)
>  - i386/kernel/cpu/cyrix.c
>  - i386/kernel/cpu/mtrr/cyrix.c
> 
> Most comments states Cyrix CPUs when they are using the macros. Is anything 
> with Cyrix 64 bit relevant? Maybe "include/asm-x86_64/processor.h" is a 
> simple copy of "include/asm-i386/processor.h" and nobody delete the unused 
> macros?

I don't think Cyrix make 64-bit stuff, surely.  Andi?

> Please keep me informed and I will resend the patch.
> 

Thanks.  I think Andi was after a better explanation of what was going
wrong with the macros, too.  Please include that in the changelog.

