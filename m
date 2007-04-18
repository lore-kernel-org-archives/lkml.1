Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXDRGRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXDRGRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXDRGRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:17:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45126 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXDRGRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:17:21 -0400
Date: Wed, 18 Apr 2007 09:17:19 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Pavel Emelianov <xemul@sw.ru>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>, linux-mm@kvack.org
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M
In-Reply-To: <20070417171213.e3cbc260.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0704180915520.11160@sbz-30.cs.Helsinki.FI>
References: <4624C3C1.9040709@sw.ru> <84144f020704170622h2b16f0f6m47ffdbb3b5686758@mail.gmail.com>
 <20070417171213.e3cbc260.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Eric Dumazet wrote:
> This nr_pages should be in struct kmem_list3, not in struct kmem_cache, 
> or else you defeat NUMA optimizations if touching a field in kmem_cache 
> at kmem_getpages()/kmem_freepages() time.

We already touch ->flags, ->gfpflags, and ->gfporder in kmem_getpages(). 
Sorry for my ignorance, but how is this different?
