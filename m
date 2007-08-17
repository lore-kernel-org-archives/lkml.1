Return-Path: <linux-kernel-owner+w=401wt.eu-S1764635AbXHQV2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764635AbXHQV2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXHQV16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:27:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33195
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758070AbXHQV15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:27:57 -0400
Date: Fri, 17 Aug 2007 14:27:56 -0700 (PDT)
Message-Id: <20070817.142756.65194845.davem@davemloft.net>
To: rdreier@cisco.com
Cc: tom@opengridcomputing.com, jeff@garzik.org, swise@opengridcomputing.com,
       mshefty@ichips.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaodh6x7js.fsf@cisco.com>
References: <1187271791.4685.9.camel@trinity.ogc.int>
	<20070816.141751.115907875.davem@davemloft.net>
	<adaodh6x7js.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 17 Aug 2007 12:52:39 -0700

>  > When using RDMA you lose the capability to do packet shaping,
>  > classification, and all the other wonderful networking facilities
>  > you've grown to love and use over the years.
> 
> Same thing with TSO and LRO and who knows what else.

Not true at all.  Full classification and filtering still is usable
with TSO and LRO.
