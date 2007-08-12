Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbXHLKVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbXHLKVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbXHLKVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:21:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbXHLKVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:21:07 -0400
From: Andi Kleen <ak@suse.de>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [2.6.20.16 review 08/28] x86_64: allocate sparsemem memmap above 4G
Date: Sun, 12 Aug 2007 12:18:11 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
References: <20070811184752.%N@1wt.eu> <20070811184837.%N@1wt.eu>
In-Reply-To: <20070811184837.%N@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121218.12411.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 August 2007 21:48, Willy Tarreau wrote:
> On systems with huge amount of physical memory, VFS cache and memory memmap
> may eat all available system memory under 4G, then the system may fail to
> allocate swiotlb bounce buffer.
>
> There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix dose
> not cover sparsemem model.

Have you checked if sparsemem even worked in 2.6.20? Irc it was quite
unstable a couple of releases ago. There were times where it rarely
booted on x86-64 because so few people test it. 
If not the patch is not needed, although relatively harmless too.

-Andi
