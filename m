Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbXGYUK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbXGYUK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXGYUKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:10:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbXGYUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:10:50 -0400
Date: Wed, 25 Jul 2007 13:10:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: bob.picco@hp.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of memmap on IA64 SPARSEMEM when
 mem_section is not a power of 2
Message-Id: <20070725131003.1bb80194.akpm@linux-foundation.org>
In-Reply-To: <20070725125501.GA32445@skynet.ie>
References: <20070313104201.GA16842@skynet.ie>
	<20070724220116.0d9fb8b5.akpm@linux-foundation.org>
	<20070725125501.GA32445@skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 13:55:02 +0100
mel@skynet.ie (Mel Gorman) wrote:

> > mm/sparse.c: In function `sparse_init':
> > mm/sparse.c:482: error: implicit declaration of function `sparse_early_usemap_alloc'
> > mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> > mm/sparse.c: In function `sparse_add_one_section':
> > mm/sparse.c:553: error: implicit declaration of function `__kmalloc_section_usemap'
> > mm/sparse.c:553: warning: assignment makes pointer from integer without a cast
> 
> I'm looking at this now and getting a superh cross-compiler built to
> build-test any fix. My first impression is that
> sparse_early_usemap_alloc() needs to be defined whether
> CONFIG_SPARSEMEM_VMEMMAP is set or not. Right now,
> sparse_early_usemap_alloc() is only defined when it is set and it's not
> clear why although "by accident" is the most likely explanation.
> 

Thanks.

There's an sh cross-compiler in http://userweb.kernel.org/~akpm/cross-compilers/,
btw.
