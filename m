Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXDMKyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXDMKyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 06:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXDMKyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 06:54:08 -0400
Received: from mail.suse.de ([195.135.220.2]:50082 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbXDMKyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 06:54:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] generic rwsems
Date: Fri, 13 Apr 2007 12:53:49 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070413100416.GC31487@wotan.suse.de>
In-Reply-To: <20070413100416.GC31487@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704131253.49301.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 12:04:16 Nick Piggin wrote:
> OK, this patch is against 2.6.21-rc6 + Mathieu's atomic_long patches.
> 
> Last time this came up I was asked to get some numbers, so here are
> some in the changelog, captured with a simple kernel module tester.
> I got motivated again because of the MySQL/glibc/mmap_sem issue.
> 
> This patch converts all architectures to a generic rwsem implementation,
> which will compile down to the same code for i386, or powerpc, for
> example, and will allow some (eg. x86-64) to move away from spinlock
> based rwsems.
> 
> Comments?

Fine for me from the x86-64 side. Some more validation with a test suite
would be good though.

-Andi
