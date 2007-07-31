Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXGaR5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXGaR5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760506AbXGaR5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:57:11 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:46451 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759722AbXGaR5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:57:09 -0400
Message-ID: <46AF77F4.2000003@opengridcomputing.com>
Date: Tue, 31 Jul 2007 12:57:08 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.23 1/2] Make the iw_cxgb3 module parameters writable.
References: <20070729201226.31659.85900.stgit@dell3.ogc.int> <adad4y9skxm.fsf@cisco.com>
In-Reply-To: <adad4y9skxm.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> ugh, missed these before my last merge...
> 
> anyway:
> 
> why do we want to parameters writable?  a good changelog tells me
> what, why and how, and this changelog just covered the "what".  Also,
> I assume you've checked that it's OK for these variables to change at
> any time?

I want to be able to changes these parameters at run time.  Eventually, 
if we might want these parameters as rdma connection setup parameters. 
For now, its useful to be able to set them without reloading.

Also, it is safe to change them at any time.  All of these are read once 
and utilized at connection setup.  So changing them is safe in that 
existing connections aren't affected, and only subsequent connections 
will utilize the new values.

Sorry for the terse changelog...


Steve.



