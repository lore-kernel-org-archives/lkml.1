Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZKTAT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZKTAT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZKTATZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:19:25 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:14072 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbZKTATY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:19:24 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAENvBUurRN+K/2dsb2JhbAC+BJdxhDsE
X-IronPort-AV: E=Sophos;i="4.44,773,1249257600"; 
   d="scan'208";a="203406806"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, sean.hefty@intel.com
Cc: general@lists.openfabrics.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: infiniband tree build failure
References: <20091120110342.5128b8f8.sfr@canb.auug.org.au>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 19 Nov 2009 16:19:29 -0800
In-Reply-To: <20091120110342.5128b8f8.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Fri, 20 Nov 2009 11:03:42 +1100")
Message-ID: <ada1vju6oa6.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Nov 2009 00:19:30.0034 (UTC) FILETIME=[20798520:01CA6977]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
 > 
 > ERROR: ".__ipv6_addr_type" [drivers/infiniband/core/rdma_cm.ko] undefined!
 > 
 > I have used the version of the infiniband tree from next-20091119 for
 > today.

Sorry, will track it down.  Sean this probably came from your patches,
any idea off the top of your head?
