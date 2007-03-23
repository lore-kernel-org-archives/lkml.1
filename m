Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbXCWBZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbXCWBZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934257AbXCWBZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:25:28 -0400
Received: from graphe.net ([209.204.138.32]:50604 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934265AbXCWBZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:25:27 -0400
Date: Thu, 22 Mar 2007 18:25:16 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA
 cache_free_alien() very expensive because of virt_to_slab(objp); nodeid =
 slabp->nodeid;)
In-Reply-To: <20070322224045.GA3200@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0703221825050.13376@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
 <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org>
 <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com>
 <4602FF57.7030001@cosmosbay.com> <20070322224045.GA3200@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007, Siddha, Suresh B wrote:

> > You should check num_possible_nodes(), or nr_node_ids (this one is cheaper, 
> > its a variable instead of a function call)
> 
> But that is based on compile time option, isn't it? Perhaps I need
> to use some other mechanism to find out the platform is not NUMA capable..

No its runtime.

