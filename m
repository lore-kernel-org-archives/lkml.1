Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbYFSIML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbYFSIML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 04:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbYFSIL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 04:11:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:43175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbYFSIL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 04:11:56 -0400
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
From: Peter Zijlstra <peterz@infradead.org>
To: Ryan Hope <rmh3093@gmail.com>
Cc: linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 10:12:02 +0200
Message-Id: <1213863122.16944.257.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 17:15 -0400, Ryan Hope wrote:
> I applied the following patches from 2.6-26-rc5-mm3 to 2.6.26-rc6 and
> they caused a hardlock under heavy IO:

What kind of machine, how much memory, how many spindles, what
filesystem and what is heavy load?

Furthermore, try the NMI watchdog with serial/net-console to capture its
output.

> x86-implement-pte_special.patch
> mm-introduce-get_user_pages_fast.patch
> mm-introduce-get_user_pages_fast-fix.patch
> mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
> x86-lockless-get_user_pages_fast.patch
> x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
> x86-lockless-get_user_pages_fast-fix.patch
> x86-lockless-get_user_pages_fast-fix-2.patch
> x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
> x86-lockless-get_user_pages_fast-fix-warning.patch
> dio-use-get_user_pages_fast.patch
> splice-use-get_user_pages_fast.patch
> x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
> #
> mm-readahead-scan-lockless.patch
> radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
> #mm-speculative-page-references.patch: clameter saw bustage
> mm-speculative-page-references.patch
> mm-speculative-page-references-fix.patch
> mm-speculative-page-references-fix-fix.patch
> mm-speculative-page-references-hugh-fix3.patch
> mm-lockless-pagecache.patch
> mm-spinlock-tree_lock.patch
> powerpc-implement-pte_special.patch
> 
> I am on an x86_64. I dont know what other info you need...


