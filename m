Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXHSHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXHSHBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbXHSHBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:01:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:18142 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXHSHBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,280,1183359600"; 
   d="scan'208";a="265103573"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'David Miller'" <davem@davemloft.net>, <rdreier@cisco.com>
Cc: <jeff@garzik.org>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
References: <adafy2hyc04.fsf@cisco.com><20070817.170033.63993876.davem@davemloft.net><adatzqxwh56.fsf@cisco.com> <20070817.234405.66176298.davem@davemloft.net>
Subject: RE: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP portsfrom the host TCP port space.
Date: Sun, 19 Aug 2007 00:01:07 -0700
Message-ID: <000001c7e22e$b7b90f00$29c8180a@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070817.234405.66176298.davem@davemloft.net>
Thread-Index: AcfhYy/qP0RatVlFTpKHwCY8j0n61wAxKRiQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-OriginalArrivalTime: 19 Aug 2007 07:01:07.0900 (UTC) FILETIME=[B78A0FC0:01C7E22E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Just be realistic and accept that RDMA is a point in time solution,
>and like any other such technology takes flexibility away from users.

All technologies are just point in time solutions.  While management is
important, shouldn't the customers decide how important it is relative to their
problems?  Whether some future technology will be better matters little if a
problem needs to be solved today.

>If you can't see that this is the future, you have my condolences.
>Because frankly, the signs are all around that this is where things
>are going.

Adding a bazillion cores to a processor doesn't do a thing to help memory
bandwidth.

Millions of Infiniband ports are in operation today.  Over 25% of the top 500
supercomputers use Infiniband.  The formation of the OpenFabrics Alliance was
pushed and has been continuously funded by an RDMA customer - the US National
Labs.  RDMA technologies are backed by Cisco, IBM, Intel, QLogic, Sun, Voltaire,
Mellanox, NetApp, AMD, Dell, HP, Oracle, Unisys, Emulex, Hitachi, NEC, Fujitsu,
LSI, SGI, Sandia, and at least two dozen other companies.  IDC expects
Infiniband adapter revenue to triple between 2006 and 2011, and switch revenue
to increase six-fold (combined revenues of 1 billion).

Customers see real benefits using channel based architectures.  Do all customers
need it?  Of course not.  Is it a niche?  Yes, but I would say that about any
10+ gig network.  That doesn't mean that it hasn't become essential for some
customers.

- Sean
