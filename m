Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbXEIUtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbXEIUtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXEIUs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:48:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbXEIUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:48:55 -0400
Date: Wed, 9 May 2007 13:48:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ollie Wild" <aaw@google.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
Subject: Re: [patch] removes MAX_ARG_PAGES
Message-Id: <20070509134815.81cb9aa9.akpm@linux-foundation.org>
In-Reply-To: <65dd6fd50705060151m78bb9b4fpcb941b16a8c4709e@mail.gmail.com>
References: <65dd6fd50705060151m78bb9b4fpcb941b16a8c4709e@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007 01:51:34 -0700
"Ollie Wild" <aaw@google.com> wrote:

> A while back, I sent out a preliminary patch
> (http://thread.gmane.org/gmane.linux.ports.hppa/752) to remove the
> MAX_ARG_PAGES limit on command line sizes.  Since then, Peter Zijlstra
> and I have fixed a number of bugs and addressed the various
> outstanding issues.
> 
> The attached patch incorporates the following changes:
> 
> - Fixes a BUG_ON() assertion failure discovered by Ingo Molnar.
> - Adds CONFIG_STACK_GROWSUP (parisc) support.
> - Adds auditing support.
> - Reverts to the old behavior on architectures with no MMU.
> - Fixes broken execution of 64-bit binaries from 32-bit binaries.
> - Adds elf_fdpic support.
> - Fixes cache coherency bugs.
> 
> We've tested the following architectures: i386, x86_64, um/i386,
> parisc, and frv.  These are representative of the various scenarios
> which this patch addresses, but other architecture teams should try it
> out to make sure there aren't any unexpected gotchas.

I'll duck this for now, given the couple of problems which people have reported.

But please keep going ;)  We sorely need this.
