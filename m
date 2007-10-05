Return-Path: <linux-kernel-owner+w=401wt.eu-S1764064AbXJEXLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764064AbXJEXLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbXJEXLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:11:15 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:40169 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbXJEXLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:11:13 -0400
X-IronPort-AV: E=Sophos;i="4.21,237,1188802800"; 
   d="scan'208";a="532044632"
To: "Sean Hefty" <sean.hefty@intel.com>
Cc: <general@lists.openfabrics.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <adahclymos8.fsf@cisco.com>
	<000401c7f632$c993e8e0$65cc180a@amr.corp.intel.com>
	<adatzpyl1mm.fsf@cisco.com>
	<000001c7f6f7$074584e0$9c98070a@amr.corp.intel.com>
	<adaprzxgyoi.fsf@cisco.com>
	<000601c80525$0b661f30$ff0da8c0@amr.corp.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 05 Oct 2007 16:10:59 -0700
In-Reply-To: <000601c80525$0b661f30$ff0da8c0@amr.corp.intel.com> (Sean Hefty's message of "Tue, 2 Oct 2007 11:50:04 -0700")
Message-ID: <adave9lkvi4.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Oct 2007 23:11:00.0136 (UTC) FILETIME=[FE3ADA80:01C807A4]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I tested this by simulating a slow passive side responder, and it worked as
 > expected for those tests.  Using an MRA does add another MAD to the CM exchange,
 > which is why it is sent only after seeing a duplicate request.  Alternatively,
 > we can take the OFED module parameter patch.

What the heck, I added this for 2.6.24.  If it doesn't work out we can
back it out.

 - R.
