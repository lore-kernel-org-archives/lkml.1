Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXCOHjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXCOHjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbXCOHjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:39:35 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933413AbXCOHje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:39:34 -0400
Date: Thu, 15 Mar 2007 00:39:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       ak@suse.com, holt@sgi.com, linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
Message-Id: <20070315003916.8a78dd0c.akpm@linux-foundation.org>
In-Reply-To: <20070315.003118.41650094.davem@davemloft.net>
References: <20070312.192616.63128242.davem@davemloft.net>
	<20070312.193211.30184040.davem@davemloft.net>
	<20070315002249.9e531578.akpm@linux-foundation.org>
	<20070315.003118.41650094.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 15 Mar 2007 00:31:18 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 15 Mar 2007 00:22:49 -0800
> 
> > So...  what would happen if sparc64 were to use neither quicklists nor
> > slab?  Just grab these pages from the page allocator and clear them?
> 
> The page table allocator is heavier weight than the quicklists,
> although obviously not as heavy weight as SLAB.

Spose so, although only in the case where we go into the buddy lists, I hope.

otoh, releasing a cache-hot page into the page allocator makes it available for
other use.

It'd be nice if you could run the numbers sometime, please - if it's OK then
we can remove code...
