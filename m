Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbXKLTok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbXKLTok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXKLTod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:44:33 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57217 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbXKLToc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:44:32 -0500
Date: Mon, 12 Nov 2007 11:44:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: linux-netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression
 with tbench
In-Reply-To: <200711101229.35822.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0711121144001.26936@schroedinger.engr.sgi.com>
References: <200711092336.56172.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0711090928270.14601@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711091533300.17621@schroedinger.engr.sgi.com>
 <200711101229.35822.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007, Nick Piggin wrote:

> BTW. your size-2048 kmalloc cache is order-1 in the default setup,
> wheras kmalloc(1024) or kmalloc(4096) will be order-0 allocations. And
> SLAB also uses order-0 for size-2048. It would be nice if SLUB did the
> same...

You can try to see the effect that order 0 would have by booting with

slub_max_order=0
