Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbXKBPVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbXKBPVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXKBPU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:20:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45039 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbXKBPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:20:55 -0400
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
	access overhead
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
In-Reply-To: <Pine.LNX.4.64.0711020734070.26635@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com>
	 <20071101.153824.91808126.davem@davemloft.net>
	 <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com>
	 <20071101.155805.65012933.davem@davemloft.net>
	 <1193999326.27652.348.camel@twins>
	 <Pine.LNX.4.64.0711020734070.26635@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 16:20:36 +0100
Message-Id: <1194016836.27652.406.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 07:35 -0700, Christoph Lameter wrote:

> Well I wonder if I should introduce it not as a replacement but as an 
> alternative to allocpercpu? We can then gradually switch over. The 
> existing API does not allow the specification of gfp_masks or alignements.

I've thought about suggesting that very thing. However, I think we need
to have a clear view of where we're going with that so that we don't end
up with two per cpu allocators because some users could not be converted
over or some such.




