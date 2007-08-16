Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbXHPEVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbXHPEVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 00:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXHPEVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 00:21:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:39056 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXHPEVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 00:21:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,269,1183359600"; 
   d="scan'208";a="279561129"
Message-ID: <46C3D09B.6060405@intel.com>
Date: Wed, 15 Aug 2007 21:20:43 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/infiniband/mlx/mad.c misplaced ;
References: <20070815235825.GB17004@redhat.com>	 <1187224811.5906.55.camel@localhost>  <46C3B428.4000003@intel.com> <1187234225.5906.73.camel@localhost>
In-Reply-To: <1187234225.5906.73.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2007-08-15 at 19:19 -0700, Kok, Auke wrote:
>> Joe Perches wrote:
>>> On Wed, 2007-08-15 at 19:58 -0400, Dave Jones wrote:
>>> There's more than a few of these (not inspected).
>>> $ egrep -r --include=*.c "\bif[[:space:]]*\([^\)]*\)[[:space:]]*\;" * 
>>> arch/sh/boards/se/7343/io.c:    if (0) ;
>>> drivers/atm/iphase.c:     if (!desc1) ;
>>> drivers/infiniband/hw/mlx4/mad.c:       if (!err);
>>> drivers/isdn/capi/capiutil.c:   else if (c <= 0x0f);
>>> drivers/net/tokenring/ibmtr.c:  else if (ti->shared_ram_paging == 0xf);  /* No paging in adapter */
>>> drivers/s390/scsi/zfcp_erp.c:           if (status == ZFCP_ERP_SUCCEEDED) ;     /* no further action */
>>> fs/hostfs/hostfs_user.c:        if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
>>> net/netfilter/xt_u32.c:         if (skb->len < 4 || pos > skb->len - 4);
>>> sound/pci/au88x0/au88x0_synth.c:                                if (eax == 0) ;
>> sounds like an excellent candidate check for checkpatch.pl !!!
> 
> I think it's poor style and all of these should go away.
> 
> the netfilter one appears to be a real error too.

I was more thinking of making sure that none of these slip back in...

Auke
