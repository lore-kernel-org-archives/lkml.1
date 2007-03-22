Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXCVWlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXCVWlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbXCVWlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:41:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:12761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXCVWlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:41:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,316,1170662400"; 
   d="scan'208"; a="62614008:sNHT20305791"
Date: Thu, 22 Mar 2007 15:40:45 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;)
Message-ID: <20070322224045.GA3200@linux-os.sc.intel.com>
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org> <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com> <4602FF57.7030001@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4602FF57.7030001@cosmosbay.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 11:12:39PM +0100, Eric Dumazet wrote:
> Siddha, Suresh B a écrit :
> >+	if (num_online_nodes() == 1)
> >+		use_alien_caches = 0;
> >+
> 
> Unfortunatly this part is wrong.

oops.

> 
> You should check num_possible_nodes(), or nr_node_ids (this one is cheaper, 
> its a variable instead of a function call)

But that is based on compile time option, isn't it? Perhaps I need
to use some other mechanism to find out the platform is not NUMA capable..

thanks,
suresh
