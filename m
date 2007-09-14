Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXINQJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXINQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759168AbXINQJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:09:16 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:20757 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbXINQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:09:14 -0400
X-IronPort-AV: E=Sophos;i="4.20,256,1186383600"; 
   d="scan'208";a="524063503"
To: Shirley Ma <xma@us.ibm.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <OFAE678C61.64C333F1-ON87257355.007A0B34-88257355.004E6EAD@us.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 14 Sep 2007 09:09:13 -0700
In-Reply-To: <OFAE678C61.64C333F1-ON87257355.007A0B34-88257355.004E6EAD@us.ibm.com> (Shirley Ma's message of "Thu, 13 Sep 2007 15:16:40 -0700")
Message-ID: <adazlzpjkk6.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Sep 2007 16:09:13.0512 (UTC) FILETIME=[97A1BA80:01C7F6E9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The patch is just needed to pick up broadcast MTU size instead of hard
 > coding 2K right now. SKB allocation shouldn't be different with Ethernet
 > Jambo Frame and IPoIB-CM which 64K MTU. I don't understand why it's
 > different. Could you please explain this?

It's exactly the same problem as ethernet jumbo frames.  A web search
for '"order 1" failure e1000' might be interesting.

IPoIB CM handles this properly by gathering together single pages in
skbs' fragment lists.

 - R.
