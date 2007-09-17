Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbXIQVrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbXIQVrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbXIQVrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:47:45 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:57052 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbXIQVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:47:43 -0400
X-IronPort-AV: E=Sophos;i="4.20,266,1186383600"; 
   d="scan'208";a="524842820"
To: Shirley Ma <xma@us.ibm.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <OF1B5CCF10.3CE4B194-ON87257356.00661AD2-88257356.0065F05E@us.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 17 Sep 2007 14:47:42 -0700
In-Reply-To: <OF1B5CCF10.3CE4B194-ON87257356.00661AD2-88257356.0065F05E@us.ibm.com> (Shirley Ma's message of "Fri, 14 Sep 2007 11:36:12 -0700")
Message-ID: <ada1wcxnev5.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2007 21:47:42.0409 (UTC) FILETIME=[5FEABB90:01C7F974]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > IPoIB CM handles this properly by gathering together single pages in
 > > skbs' fragment lists.

 > Then can we reuse IPoIB CM code here?

Yes, if possible, refactoring things so that the rx skb allocation
code becomes common between CM and non-CM would definitely make sense.
