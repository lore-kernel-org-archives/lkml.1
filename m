Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbXKNCAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbXKNCAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbXKNCAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:00:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32798
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756986AbXKNCAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:00:09 -0500
Date: Tue, 13 Nov 2007 18:00:09 -0800 (PST)
Message-Id: <20071113.180009.56326652.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711131748570.6539@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711131418560.4363@schroedinger.engr.sgi.com>
	<20071113.173718.112153027.davem@davemloft.net>
	<Pine.LNX.4.64.0711131748570.6539@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 13 Nov 2007 17:50:24 -0800 (PST)

> On Tue, 13 Nov 2007, David Miller wrote:
> 
> > BTW, I'm going to stop testing your patches on sparc64 for
> > a while until you start to make me feel like you understand
> > that ignoring the BSS bloat issue is bad.
> 
> Well this is just the fallback. How can I avoid this and still keep a 
> constant? Add a new segment to vmlinux.lds.S?

I'm not so sure.

The idea about doling out vmalloc space seemed the most promising.
