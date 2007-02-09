Return-Path: <linux-kernel-owner+w=401wt.eu-S1945989AbXBIBmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945989AbXBIBmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946000AbXBIBmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:42:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:35741 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945989AbXBIBmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:42:15 -0500
Subject: Re: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem (try
	2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702090027580.29905@blonde.wat.veritas.com>
References: <20070208111421.30513.77904.sendpatchset@linux.site>
	 <Pine.LNX.4.64.0702090027580.29905@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 12:41:35 +1100
Message-Id: <1170985295.2620.389.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Fix threaded user page write memory ordering
> 
> Make sure we order the writes to a newly created page
> with the page table update that potentially exposes the
> page to another CPU.
> 
> This is a no-op on any architecture where getting the
> page table spinlock will already do the ordering (notably
> x86), but other architectures can care.


Ah yes, the clear_* ones I knew about as I'm the one who tracked down
that bug on power :-) I though the ones Nick pointed out were different
tho.

Ben.


