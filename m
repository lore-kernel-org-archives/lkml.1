Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYCUTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYCUTGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYCUTG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:06:26 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46387 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754661AbYCUTG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:06:26 -0400
Date: Fri, 21 Mar 2008 12:04:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
In-Reply-To: <20080321190258.GF6571@elte.hu>
Message-ID: <Pine.LNX.4.64.0803211201530.19432@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061726.782068299@sgi.com>
 <20080321.002502.223136918.davem@davemloft.net> <20080321083952.GA20454@elte.hu>
 <Pine.LNX.4.64.0803211032390.18671@schroedinger.engr.sgi.com>
 <20080321190258.GF6571@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Ingo Molnar wrote:

> your patch indeed does not introduce it here, but 
> KERNEL_STACK_SIZE_ORDER shows up in the x86 portion of your patch and 
> you refer to multi-order stack allocations in your 0/14 mail :-)

Ahh. I see. Remnants from V2 in IA64 code. That portion has to be removed 
because of the software TLB issues on IA64 as pointed out by Dave.

