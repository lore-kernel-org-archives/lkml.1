Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbXHQXbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbXHQXbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 19:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbXHQXbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 19:31:32 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:2410 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbXHQXba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 19:31:30 -0400
X-IronPort-AV: i="4.19,277,1183359600"; 
   d="scan'208"; a="514739252:sNHT48637412"
To: David Miller <davem@davemloft.net>
Cc: tom@opengridcomputing.com, jeff@garzik.org, swise@opengridcomputing.com,
       mshefty@ichips.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports from the host TCP port space.
X-Message-Flag: Warning: May contain useful information
References: <1187271791.4685.9.camel@trinity.ogc.int>
	<20070816.141751.115907875.davem@davemloft.net>
	<adaodh6x7js.fsf@cisco.com>
	<20070817.142756.65194845.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 17 Aug 2007 16:31:07 -0700
In-Reply-To: <20070817.142756.65194845.davem@davemloft.net> (David Miller's message of "Fri, 17 Aug 2007 14:27:56 -0700 (PDT)")
Message-ID: <adafy2hyc04.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Aug 2007 23:31:07.0587 (UTC) FILETIME=[AFAF8130:01C7E126]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  > When using RDMA you lose the capability to do packet shaping,
 > >  > classification, and all the other wonderful networking facilities
 > >  > you've grown to love and use over the years.
 > > 
 > > Same thing with TSO and LRO and who knows what else.
 > 
 > Not true at all.  Full classification and filtering still is usable
 > with TSO and LRO.

Well, obviously with TSO and LRO the packets that the stack sends or
receives are not the same as what's on the wire.  Whether that breaks
your wonderful networking facilities or not depends on the specifics
of the particular facility I guess -- for example shaping is clearly
broken by TSO.  (And people can wonder what the packet trains TSO
creates do to congestion control on the internet, but the netdev crowd
has already decided that TSO is "good" and RDMA is "bad")

 - R.
