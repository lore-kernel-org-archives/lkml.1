Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXI1V1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXI1V1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXI1V1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:27:07 -0400
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:43169 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbXI1V1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:27:06 -0400
Message-ID: <46FD71AA.8070901@opengridcomputing.com>
Date: Fri, 28 Sep 2007 16:27:06 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Kanevsky, Arkady" <Arkady.Kanevsky@netapp.com>
CC: Sean Hefty <sean.hefty@intel.com>, Sean Hefty <mshefty@ichips.intel.com>,
       netdev@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH v3] iw_cxgb3: Support"iwarp-only"interfacesto
 avoid 4-tuple conflicts.
References: <20070923203649.8324.64524.stgit@dell3.ogc.int><46FBF8AF.9040700@ichips.intel.com><C98692FD98048C41885E0B0FACD9DFB805187514@exnane01.hq.netapp.com> <000101c8013a$41b374f0$a7cc180a@amr.corp.intel.com> <C98692FD98048C41885E0B0FACD9DFB80518755A@exnane01.hq.netapp.com> <46FD5A2F.7010409@opengridcomputing.com> <C98692FD98048C41885E0B0FACD9DFB805187762@exnane01.hq.netapp.com>
In-Reply-To: <C98692FD98048C41885E0B0FACD9DFB805187762@exnane01.hq.netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Kanevsky, Arkady wrote:
> Exactly,
> it forces the burden on administrator.
> And one will be forced to try one mount for iWARP and it does not
> work issue another one TCP or UDP if it fails.
> Yack!
>

I see your point.  I have no defense.  My hands have been tied on fixing 
this properly...

> And server will need to listen on different IP address and simple
> * will not work since it will need to listen in two different domains.
> 

No, the server will listen on 0.0.0.0:2049 for TCP, and 0.0.0.0:2050 for 
rdma.  The rdma subsystem will translate 0.0.0.0:2050 into listens on 
specific iwarp ip addresses on every iwarp device...

> Had we run this proposal by administrators?

There has been no other solution proposed that Dave Miller and Jeff 
Garzik won't NAK...

Steve.
