Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXG0MiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXG0MiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXG0MiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:38:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:38169 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbXG0MiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:38:05 -0400
Subject: Re: [PATCH/RFC] remove frv usage of flush_tlb_pgtables()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <21776.1185529438@redhat.com>
References: <1185493838.5495.144.camel@localhost.localdomain>
	 <21776.1185529438@redhat.com>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 22:37:54 +1000
Message-Id: <1185539874.5495.225.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 10:43 +0100, David Howells wrote:
> > frv is the last user in the tree of that dubious hook, and it's my
> > understanding that it's not even needed. It's only called by
> memory.c
> > free_pgd_range() which is always called within an mmu_gather, and
> > tlb_flush() on frv will do a flush_tlb_mm(), which from my reading
> > of the code, seems to do what flush_tlb_ptables() does, which is
> > to clear the cached PGE.
> 
> Yeah...  I hadn't got around to killing myself yet.

Ahem... hopefully you won't get around to it any time soon :-)

Cheers,
Ben.


