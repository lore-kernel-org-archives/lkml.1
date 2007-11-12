Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbXKLTtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbXKLTtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbXKLTtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:49:03 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:35438 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbXKLTtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:49:01 -0500
Message-ID: <4738AE04.1030506@cosmosbay.com>
Date: Mon, 12 Nov 2007 20:48:20 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
References: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0711121112410.26682@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711121112410.26682@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 12 Nov 2007 20:48:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Mon, 12 Nov 2007, Herbert Xu wrote:
> 
>> David Miller <davem@davemloft.net> wrote:
>>> Each IP compression tunnel instance does an alloc_percpu().
>> Actually all IPComp tunnels share one set of objects which are
>> allocated per-cpu.  So only the first tunnel would do that.
> 
> Ahh so the need to be able to expand per cpu memory storage on demand 
> is not as critical as we thought.
> 

Yes, but still desirable for future optimizations.

For example, I do think using a per cpu memory storage on net_device refcnt & 
last_rx could give us some speedups.



