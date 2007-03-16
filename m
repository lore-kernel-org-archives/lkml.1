Return-Path: <linux-kernel-owner+w=401wt.eu-S965911AbXCPUwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965911AbXCPUwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965912AbXCPUwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:52:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50487 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965911AbXCPUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:52:21 -0400
Date: Fri, 16 Mar 2007 13:52:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, rostedt@goodmis.org, torvalds@linux-foundation.org,
       mbligh@mbligh.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, chrisw@sous-sol.org, rusty@rustcorp.com.au,
       glommer@gmail.com
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070316.134718.95058720.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0703161350260.6204@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
 <20070316114415.GA26403@one.firstfloor.org> <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
 <20070316.134718.95058720.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, David Miller wrote:

> > It is primarily a performance improvement since the sparsemem table 
> > lookups would no longer be necessary and it also streamlines other 
> > frequent cacheline uses. These page -> page_struct and vice versa 
> > operations are key to the performance of various subsystem among them 
> > the slab allocator.
> 
> If you set the bit range small enough and don't use sparsemem-extreme,
> the cost is extremely low considering the flexibility you obtain.

What flexibility? 
 
> There are always going to be holes on large systems, there isn't
> really a way to avoid this given how addressing is done on those
> machines.

Virtual mmap allows holes in the same way as page tables do. These 
structures were designed for sparseness. I really do not think we should 
rediscuss the material here that was discussed on linux-mm. The outcome of 
that was that we will introduce virtual memmap to reduce sparsemem 
overhead and to increase flexibility.



