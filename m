Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXKLUS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXKLUS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 15:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXKLUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:18:47 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:53676 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXKLUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:18:46 -0500
Message-ID: <4738B509.9000305@cosmosbay.com>
Date: Mon, 12 Nov 2007 21:18:17 +0100
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
References: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0711121112410.26682@schroedinger.engr.sgi.com> <4738AE04.1030506@cosmosbay.com> <Pine.LNX.4.64.0711121154270.27051@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711121154270.27051@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 12 Nov 2007 21:18:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Mon, 12 Nov 2007, Eric Dumazet wrote:
>> For example, I do think using a per cpu memory storage on net_device refcnt &
>> last_rx could give us some speedups.
> 
> Note that there was a new patchset posted (titled cpu alloc v1) that 
> provides on demand extension of the cpu areas.
> 
> See http://marc.info/?l=linux-kernel&m=119438261304093&w=2

Thank you Christoph. I was traveling last week so I missed that.

This new patchset looks very interesting, you did a fantastic job !

