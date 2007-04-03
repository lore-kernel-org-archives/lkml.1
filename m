Return-Path: <linux-kernel-owner+w=401wt.eu-S966121AbXDCAXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966121AbXDCAXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966124AbXDCAXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:23:31 -0400
Received: from graphe.net ([209.204.138.32]:34386 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966121AbXDCAXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:23:30 -0400
Date: Mon, 2 Apr 2007 17:23:20 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA
 cache_free_alien() very expensive because of virt_to_slab(objp); nodeid =
 slabp->nodeid;)
In-Reply-To: <20070402225512.GA31026@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0704021722300.20493@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
 <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org>
 <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com>
 <4602FF57.7030001@cosmosbay.com> <20070322224045.GA3200@linux-os.sc.intel.com>
 <20070323141210.GA20548@one.firstfloor.org> <20070402225512.GA31026@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Siddha, Suresh B wrote:

> Set the node_possible_map at runtime. On a non NUMA system,
> num_possible_nodes() will now say '1'

How does this relate to nr_node_ids?

