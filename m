Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbXKHUBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbXKHUBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759421AbXKHUB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:01:27 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:41932 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754214AbXKHUB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:01:26 -0500
Date: Thu, 8 Nov 2007 12:01:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Mel Gorman <mel@skynet.ie>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/23] SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
In-Reply-To: <20071108194735.GW19691@waste.org>
Message-ID: <Pine.LNX.4.64.0711081159120.9966@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011226.844437184@sgi.com>
 <20071108145044.GB2591@skynet.ie> <20071108172548.GW17536@waste.org>
 <Pine.LNX.4.64.0711081116060.9279@schroedinger.engr.sgi.com>
 <20071108194735.GW19691@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Matt Mackall wrote:

> Not really. drivers/char/random.c does:
> 
> __get_cpu_var(trickle_count)++ & 0xfff

That is incremented on each call to add_timer_randomness. Not a high 
enough resolution there. I guess I am stuck with get_cycles().

