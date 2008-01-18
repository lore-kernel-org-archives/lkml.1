Return-Path: <linux-kernel-owner+w=401wt.eu-S1764497AbYARSvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764497AbYARSvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761257AbYARSv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:51:26 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33409 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760738AbYARSvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:51:25 -0500
Date: Fri, 18 Jan 2008 10:51:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Olaf Hering <olaf@aepfle.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Linux MM <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: crash in kmem_cache_init
In-Reply-To: <20080117211511.GA25320@aepfle.de>
Message-ID: <Pine.LNX.4.64.0801181047590.30348@schroedinger.engr.sgi.com>
References: <20080115150949.GA14089@aepfle.de>
 <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com>
 <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
 <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com>
 <20080117211511.GA25320@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Olaf Hering wrote:

>   Normal     892928 ->   892928
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     1:        0 ->   892928
> Could not find start_pfn for node 0

We only have a single node that is node 1? And then we initialize nodes 0 
to 3?

> Memory: 3496633k/3571712k available (6188k kernel code, 75080k reserved, 1324k data, 1220k bss, 304k init)
> cache_grow(2778) swapper(0):c0,j4294937299 cachep c0000000006a4fb8 nodeid 0 l3 c0000000005fddf0
> cache_grow(2778) swapper(0):c0,j4294937299 cachep c0000000006a4fb8 nodeid 1 l3 c0000000005fddf0
> cache_grow(2778) swapper(0):c0,j4294937299 cachep c0000000006a4fb8 nodeid 2 l3 c0000000005fddf0
> cache_grow(2778) swapper(0):c0,j4294937299 cachep c0000000006a4fb8 nodeid 3 l3 c0000000005fddf0

???
