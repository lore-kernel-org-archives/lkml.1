Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbXLHKMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbXLHKMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXLHKMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:12:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502AbXLHKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:12:14 -0500
Date: Sat, 8 Dec 2007 02:11:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-Id: <20071208021105.cc6d5f0a.akpm@linux-foundation.org>
In-Reply-To: <20071208093039.GA28054@elte.hu>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208093039.GA28054@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 10:30:39 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Subject		: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> > Submitter	: Ingo Molnar <mingo@elte.hu>
> > References	: http://lkml.org/lkml/2007/11/29/157
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9497
> > Handled-By	: Matt Mackall <mpm@selenic.com>
> > Patch		: http://lkml.org/lkml/2007/11/29/387
> 
> Matt, the above bug is still occuring en masse during random bootups:
> 
> [   67.828312] WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> [   41.270905] WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> [   82.378714] WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> [   35.308126] WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> [   35.484155] WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> 
> and the patch does not seem to be upstream yet.
> 

err, umm, OK, I'll go hunt it down and take a closer look at it.
