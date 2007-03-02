Return-Path: <linux-kernel-owner+w=401wt.eu-S1422863AbXCBEdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422863AbXCBEdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422864AbXCBEdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:33:10 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43453 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422863AbXCBEdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:33:08 -0500
Date: Thu, 1 Mar 2007 20:33:04 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@skynet.ie>, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <20070301202917.7abe4ad8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703012031410.14299@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703011854540.5530@schroedinger.engr.sgi.com>
 <20070302035751.GA15867@wotan.suse.de> <Pine.LNX.4.64.0703012001260.5548@schroedinger.engr.sgi.com>
 <20070301202917.7abe4ad8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007, Andrew Morton wrote:

> Sorry, but this is crap.  zones and nodes are distinct, physical concepts
> and you're kidding yourself if you think you can somehow fudge things to make
> one of them just go away.
> 
> Think: ZONE_DMA32 on an Opteron machine.  I don't think there is a sane way
> in which we can fudge away the distinction between
> bus-addresses-which-have-the-32-upper-bits-zero and
> memory-which-is-local-to-each-socket.

Of course you can. Add a virtual DMA and DMA32 zone/node and extract the 
relevant memory from the base zone/node.

