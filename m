Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZGVDyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZGVDyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZGVDyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:54:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56220
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbZGVDyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:54:14 -0400
Date: Tue, 21 Jul 2009 20:54:19 -0700 (PDT)
Message-Id: <20090721.205419.251322907.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, dhowells@redhat.com, npiggin@suse.de,
       JBeulich@novell.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       hpa@zytor.com, tglx@linutronix.de, akpm@linux-foundation.org,
       x86@kernel.org, andi@firstfloor.org
Subject: Re: [PATCH 19/20] sparc64: use embedding percpu first chunk
 allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <1248171979-29166-20-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
	<1248171979-29166-20-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Tue, 21 Jul 2009 19:26:18 +0900

> sparc64 currently allocates a large page for each cpu and partially
> remap them into vmalloc area much like what lpage first chunk
> allocator did.  As a 4M page is used for each cpu, this results in
> very large unit size and also adds TLB pressure due to the double
> mapping of pages in the first chunk.
> 
> This patch converts sparc64 to use the embedding percpu first chunk
> allocator which now knows how to handle NUMA configurations.  This
> simplifies the code a lot, doesn't incur any extra TLB pressure and
> results in better utilization of address space.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
