Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXHPDLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXHPDLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbXHPDLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:11:21 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:12340 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbXHPDLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:11:19 -0400
X-IronPort-AV: i="4.19,268,1183359600"; 
   d="scan'208"; a="200851391:sNHT47033505"
To: Jeff Garzik <jeff@garzik.org>
Cc: Steve Wise <swise@opengridcomputing.com>,
       David Miller <davem@davemloft.net>, mshefty@ichips.intel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports from the host TCP port space.
X-Message-Flag: Warning: May contain useful information
References: <46B883B5.8040702@opengridcomputing.com>
	<46BB61D0.4090101@opengridcomputing.com>
	<46BB89C0.4040303@ichips.intel.com>
	<20070809.145534.102938208.davem@davemloft.net>
	<46C310E1.7020503@opengridcomputing.com> <46C3B5EF.5060409@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 15 Aug 2007 20:11:15 -0700
In-Reply-To: <46C3B5EF.5060409@garzik.org> (Jeff Garzik's message of "Wed, 15 Aug 2007 22:26:55 -0400")
Message-ID: <adaabss41ik.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Aug 2007 03:11:15.0575 (UTC) FILETIME=[1B6F0870:01C7DFB3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Needing to reach out of the RDMA sandbox and reserve net stack
 > resources away from itself travels a path we've consistently avoided.

Where did the idea of an "RDMA sandbox" come from?  Obviously no one
disagrees with keeping things clean and maintainable, but the idea
that RDMA is a second-class citizen that doesn't get any input into
the evolution of the networking code seems kind of offensive to me.

 - R.
