Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbXKNCEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbXKNCEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbXKNCDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:03:53 -0500
Received: from relay1.sgi.com ([192.48.171.29]:38100 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754534AbXKNCDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:03:52 -0500
Date: Tue, 13 Nov 2007 18:03:51 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.180158.169883244.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711131802480.6713@schroedinger.engr.sgi.com>
References: <p73wssly6sr.fsf@bingen.suse.de> <20071113.175208.168903694.davem@davemloft.net>
 <Pine.LNX.4.64.0711131756180.6631@schroedinger.engr.sgi.com>
 <20071113.180158.169883244.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Tue, 13 Nov 2007 17:57:15 -0800 (PST)
> 
> > Hmmmm. cpu_alloc really does not need zeroed data. Just an address
> > fixed by the compiler where stuff can be put. Can the loader do that
> > somehow?
> 
> Yes, and I think IA64 uses such a scheme for it's 64KB fixed
> per-cpu TLB mapping thing doesn't it?

The per cpu TLB mapping is virtually mapped. The real memory allocation 
behind it occurs dynamically from bootmem.

