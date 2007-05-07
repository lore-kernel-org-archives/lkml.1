Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbXEGDWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbXEGDWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 23:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbXEGDWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 23:22:33 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbXEGDWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 23:22:33 -0400
Date: Sun, 6 May 2007 20:22:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: get_user_pages vs mmap MAP_FIXED bug
Message-Id: <20070506202225.ba6476b6.akpm@linux-foundation.org>
In-Reply-To: <1178501204.7731.35.camel@localhost.localdomain>
References: <1178434876.12284.175.camel@localhost.localdomain>
	<1178501204.7731.35.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2007 11:26:44 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Sun, 2007-05-06 at 17:01 +1000, Rusty Russell wrote:
> > This bug is in 2.6.21-rc7-mm2, but not 2.6.21.  Haven't tested
> > 2.6.21-mm1 yet.
> 
> OK, 2.6.21-mm1 fails too.  2.6.21-git6 ... is fine.
> 
> Here's a standalone test using ptrace.  No kernel module req'd.
> 
> 	rusty@debussy:~/linux-2.6.21-mm1$ ../examiner 
> 	ptrace says 0, child says 0x464c457f

thanks.

> Any clues Andrew?  Or should I take your patches and do a binary search?

I've been assuming that Nick's vm_operations.fault changes have broken
get_user_pages()'s manual faulting.  The next step is to wait for Nick to
turn up.

