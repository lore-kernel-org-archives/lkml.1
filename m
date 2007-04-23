Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbXDWFFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbXDWFFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXDWFFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:05:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34800 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbXDWFFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:05:07 -0400
Date: Mon, 23 Apr 2007 08:05:06 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Scott Porter <scott@opengridcomputing.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] fault injection: fix failslab with CONFIG_NUMA
In-Reply-To: <20070422091108.GB4246@APFDCB5C>
Message-ID: <Pine.LNX.4.64.0704230804490.27616@sbz-30.cs.Helsinki.FI>
References: <1177095354.25165.48.camel@scott-desktop.site>
 <1177192363.25165.101.camel@scott-desktop.site> <20070421221033.GA30496@one.firstfloor.org>
 <20070422070603.GA30662@APFDCB5C> <20070422090930.GA4246@APFDCB5C>
 <20070422091108.GB4246@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007, Akinobu Mita wrote:
> Currently failslab injects failures into ____cache_alloc().
> But with enabling CONFIG_NUMA it's not enough to let actual
> slab allocator functions (kmalloc, kmem_cache_alloc, ...) return NULL.
> 
> This patch moves fault injection hook inside of __cache_alloc() and
> __cache_alloc_node(). These are lower call path than ____cache_alloc()
> and enable to inject faulures to slab allocators with CONFIG_NUMA.

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
