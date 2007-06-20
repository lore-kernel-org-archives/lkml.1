Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbXFTNEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbXFTNEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbXFTNEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:04:43 -0400
Received: from mga07.intel.com ([143.182.124.22]:15955 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755636AbXFTNEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:04:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,442,1175497200"; 
   d="scan'208";a="241240689"
Message-ID: <46792586.20706@linux.intel.com>
Date: Wed, 20 Jun 2007 06:03:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in dma	map
 api calls
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>	 <20070619213808.798646000@askeshav-devel.jf.intel.com> <1182326799.21117.19.camel@twins>
In-Reply-To: <1182326799.21117.19.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> 
> PF_MEMALLOC as is, is meant to salvage the VM from the typical VM
> deadlock. 

.. and this IS the typical VM deadlock.. it is your storage driver 
trying to write out a piece of memory on behalf of the VM, and calls 
the iommu to map it, which then needs a bit of memory....
