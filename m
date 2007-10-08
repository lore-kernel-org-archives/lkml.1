Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbXJHXzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbXJHXzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXJHXzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:55:04 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:45207 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXJHXzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:55:01 -0400
X-IronPort-AV: E=Sophos;i="4.21,245,1188802800"; 
   d="scan'208";a="232930233"
To: Steve Wise <swise@opengridcomputing.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Updated InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <adaodfdkv59.fsf@cisco.com>
	<47090708.6060604@opengridcomputing.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 08 Oct 2007 16:54:59 -0700
In-Reply-To: <47090708.6060604@opengridcomputing.com> (Steve Wise's message of "Sun, 07 Oct 2007 11:19:20 -0500")
Message-ID: <adair5hjh64.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Oct 2007 23:55:00.0204 (UTC) FILETIME=[A31282C0:01C80A06]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > No mention about the iwarp port space issue?

I don't think we're at a stage where I'm prepared to merge something--
we all agree the latest patch has serious drawbacks, and it commits us
to a suboptimal interface that is userspace-visible.

 > I'm at a loss as to how to proceed.

Could we try to do some cleanups to the net core to make the alias
stuff less painful?  eg is there any sane way to make it possible for
a device that creates 'eth0' to also create an 'iw0' alias without an
assigning an address?

 - R.
