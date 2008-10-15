Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYJONA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYJONA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYJONAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:00:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:45675 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYJONAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:00:48 -0400
Subject: Re: Superpages Project  -  sourceforge.net/projects/linuxsuperpages
From: Peter Zijlstra <peterz@infradead.org>
To: "Wildman, Tom" <tom.wildman@hp.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@redhat.com" <alan@redhat.com>, Mel Gorman <mel@skynet.ie>
In-Reply-To: <F9E7AD49A6823D4AA5A36E1DE32F0F9B27570B8CBC@GVW1092EXB.americas.hpqcorp.net>
References: <F9E7AD49A6823D4AA5A36E1DE32F0F9B27570B8CBC@GVW1092EXB.americas.hpqcorp.net>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 15:00:47 +0200
Message-Id: <1224075647.28131.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 01:51 +0000, Wildman, Tom wrote:
> A new project has been created at SourceForge with an implementation
> of the Rice University's Superpages FreeBSD prototype that has been
> ported to the 2.6 Linux kernel for IA64, x86-64, and x86-32.
> 
> The project can be found at:
> http://sourceforge.net/projects/linuxsuperpages
> 
> The major benefit of supporting Superpages is increased memory reach
> of the processor's TLB, which reduces the number of TLB misses in
> applications that have large data sets.  Some benchmarks have been
> improved 20% in execution time.
> 
> Reference www.cs.rice.edu/~jnavarro/superpages/ for more information
> about the Rice University's Superpages project.
> 
> The project is being made available to the Open Source community to
> share the implementation and knowledge.  With the enhancements to the
> x86 architectures to support multiple and large page sizes there
> should be increased interest in this functionality.

How are you proposing to address the fun issues like online compaction
etc. ?

Furthermore, what's the added advantage of dynamic superpages over
exlpicit superpage support, eg. though the use of libhugetlb?

Unless you realize online compaction and add a kind of extend allocation
to the page allocator there will hardly ever be a situation where you
can promote a page.

All of which is rather expensive to do, changing the application might
be easier and deliver better performance gains.

