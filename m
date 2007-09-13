Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbXIMVMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbXIMVMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbXIMVMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:12:38 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:53428 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbXIMVMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:12:37 -0400
X-IronPort-AV: E=Sophos;i="4.20,251,1186383600"; 
   d="scan'208";a="175890945"
To: Jeff Garzik <jeff@garzik.org>
Cc: Steve Wise <swise@opengridcomputing.com>, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <adahclymos8.fsf@cisco.com>
	<46E97BB0.9030106@opengridcomputing.com> <46E987E0.2010605@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 13 Sep 2007 14:12:35 -0700
In-Reply-To: <46E987E0.2010605@garzik.org> (Jeff Garzik's message of "Thu, 13 Sep 2007 14:56:32 -0400")
Message-ID: <adalkbal16k.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Sep 2007 21:12:35.0507 (UTC) FILETIME=[CE740030:01C7F64A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Well, if it involves /sharing/ port space with the native stack,
 > i.e. where port 1234 is IB but 1235 is Linux, pretty much all the
 > networking devs have NAK'd that approach AFAICS.

Just to be clear, InfiniBand has no problem; the issue is port
collisions involving iWARP connections.

 - R.
