Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbXJJVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbXJJVC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbXJJVCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:02:49 -0400
Received: from mga10.intel.com ([192.55.52.92]:45906 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755582AbXJJVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:02:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,256,1188802800"; 
   d="scan'208";a="341631623"
Message-ID: <470D3D93.2020606@ichips.intel.com>
Date: Wed, 10 Oct 2007 14:01:07 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
References: <46B883B5.8040702@opengridcomputing.com>	<46BB61D0.4090101@opengridcomputing.com>	<46BB89C0.4040303@ichips.intel.com> <20070809.145534.102938208.davem@davemloft.net> <470AA729.2050009@opengridcomputing.com>
In-Reply-To: <470AA729.2050009@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The hack to use a socket and bind it to claim the port was just for 
> demostrating the idea.  The correct solution, IMO, is to enhance the 
> core low level 4-tuple allocation services to be more generic (eg: not 
> be tied to a struct sock).  Then the host tcp stack and the host rdma 
> stack can allocate TCP/iWARP ports/4tuples from this common exported 
> service and share the port space.  This allocation service could also be 
> used by other deep adapters like iscsi adapters if needed.

Since iWarp runs on top of TCP, the port space is really the same. 
FWIW, I agree that this proposal is the correct solution to support iWarp.

- Sean
