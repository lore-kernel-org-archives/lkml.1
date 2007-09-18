Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbXIRRSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbXIRRSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbXIRRSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:18:09 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:62297 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbXIRRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:18:07 -0400
X-IronPort-AV: E=Sophos;i="4.20,269,1186383600"; 
   d="scan'208";a="220383015"
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <adahclymos8.fsf@cisco.com> <20070918163433.GL2050@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 18 Sep 2007 10:18:03 -0700
In-Reply-To: <20070918163433.GL2050@mellanox.co.il> (Michael S. Tsirkin's message of "Tue, 18 Sep 2007 18:34:33 +0200")
Message-ID: <adafy1blwok.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Sep 2007 17:18:04.0418 (UTC) FILETIME=[DF7EF620:01C7FA17]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Roland, could you merge the common TX CQ patch please?
 > It actually fixes a real problem.

Yes, I will, but it collides with the net-2.6.24 NAPI rework I think,
so it may not go in until a few days after the merge window.

Have you verified that the patch cures the interrupt overload issues?
