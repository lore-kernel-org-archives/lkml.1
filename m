Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbXJIPQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbXJIPQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXJIPQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:16:37 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:18348 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbXJIPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:16:36 -0400
X-IronPort-AV: E=Sophos;i="4.21,249,1188802800"; 
   d="scan'208";a="22273610"
To: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Updated InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <adaodfdkv59.fsf@cisco.com> <47083E38.2050005@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 09 Oct 2007 08:16:34 -0700
In-Reply-To: <47083E38.2050005@linux.vnet.ibm.com> (Pradeep Satyanarayana's message of "Sat, 06 Oct 2007 19:02:32 -0700")
Message-ID: <ada7ilwjp2l.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Oct 2007 15:16:35.0330 (UTC) FILETIME=[61892620:01C80A87]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Roland, I submitted an updated patch incorporating some of Sean's comments within
 > a day or two. Rest of comments pertained to restructuring the code and adding 
 > some additional module parameters.
 > 
 > This would require more discussions since some of these had been already discussed
 > previously. We had decided upon this code structure after a lot of discussions and
 > incorporating these would be undoing some of that.

Can you give a link to your current final version of the patch?

Sean, what's your opinion of where we stand?

Since module parameters create a userspace-visible interface that we
are stuck with for a long time, we definitely have to get at least
that much right before merging.

 - R.
