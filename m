Return-Path: <linux-kernel-owner+w=401wt.eu-S966124AbXDCAcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966124AbXDCAcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966126AbXDCAcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:32:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:34805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966124AbXDCAcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:32:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,362,1170662400"; 
   d="scan'208"; a="223680322:sNHT964253031"
Date: Mon, 2 Apr 2007 17:31:07 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <christoph@lameter.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;)
Message-ID: <20070403003107.GB31026@linux-os.sc.intel.com>
References: <20070320213218.GA13952@one.firstfloor.org> <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org> <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com> <4602FF57.7030001@cosmosbay.com> <20070322224045.GA3200@linux-os.sc.intel.com> <20070323141210.GA20548@one.firstfloor.org> <20070402225512.GA31026@linux-os.sc.intel.com> <Pine.LNX.4.64.0704021722300.20493@graphe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704021722300.20493@graphe.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 05:23:20PM -0700, Christoph Lameter wrote:
> On Mon, 2 Apr 2007, Siddha, Suresh B wrote:
> 
> > Set the node_possible_map at runtime. On a non NUMA system,
> > num_possible_nodes() will now say '1'
> 
> How does this relate to nr_node_ids?

With this patch, nr_node_ids on non NUMA will also be '1' and
as before nr_node_ids is same as num_possible_nodes()

thanks,
suresh
