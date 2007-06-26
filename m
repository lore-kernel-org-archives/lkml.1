Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbXFZTTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbXFZTTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbXFZTTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:19:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38317 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757286AbXFZTTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:19:25 -0400
Date: Tue, 26 Jun 2007 12:19:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nish Aravamudan <nish.aravamudan@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
Subject: Re: [patch 12/26] SLUB: Slab defragmentation core
In-Reply-To: <29495f1d0706261213w73b7cbe0weabdcb2b03a9b880@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706261217250.20282@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com>  <20070618095916.297690463@sgi.com>
 <29495f1d0706261213w73b7cbe0weabdcb2b03a9b880@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Nish Aravamudan wrote:

> >    kmem_cache_defrag takes a node parameter. This can either be -1 if
> >    defragmentation should be performed on all nodes, or a node number.
> >    If a node number was specified then defragmentation is only performed
> >    on a specific node.
> 
> Hrm, isn't -1 usually 'this node' for NUMA systems? Maybe nr_node_ids
> or MAX_NUMNODES should mean 'all nodes'?

-1 means no node specified. What the function does in this case depends
on the function. For "this node" you can use numa_node_id().
