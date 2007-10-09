Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbXJIRSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbXJIRSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXJIRSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:18:46 -0400
Received: from mga07.intel.com ([143.182.124.22]:6331 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751371AbXJIRSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:18:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,249,1188802800"; 
   d="scan'208";a="295447747"
Message-ID: <470BB7ED.7070007@ichips.intel.com>
Date: Tue, 09 Oct 2007 10:18:37 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Updated InfiniBand/RDMA merge plans for 2.6.24
References: <adaodfdkv59.fsf@cisco.com> <47083E38.2050005@linux.vnet.ibm.com> <ada7ilwjp2l.fsf@cisco.com>
In-Reply-To: <ada7ilwjp2l.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you give a link to your current final version of the patch?
> 
> Sean, what's your opinion of where we stand?

Let me look back over the last version that was sent and reply back 
later today or tomorrow.  Several of my initial comments were on code 
structure.

> Since module parameters create a userspace-visible interface that we
> are stuck with for a long time, we definitely have to get at least
> that much right before merging.

I was taking a slightly different view of the design.  It would be nice 
to agree on whether SRQ should be separated from the QP type before 
merging upstream, even if the implementation doesn't immediately support 
all available options.

- Sean
