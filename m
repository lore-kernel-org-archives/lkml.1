Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbXIWUdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbXIWUdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 16:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXIWUdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 16:33:35 -0400
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:38631 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbXIWUde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 16:33:34 -0400
Message-ID: <46F6CD9F.9090606@opengridcomputing.com>
Date: Sun, 23 Sep 2007 15:33:35 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Sean Hefty <mshefty@ichips.intel.com>
CC: rdreier@cisco.com, sean.hefty@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH v2] iw_cxgb3: Support "iwarp-only" interfaces
 to avoid 4-tuple conflicts.
References: <20070913191617.30937.95960.stgit@dell3.ogc.int> <46E99586.90905@ichips.intel.com>
In-Reply-To: <46E99586.90905@ichips.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Sean Hefty wrote:
>> The iWARP driver must translate all listens on address 0.0.0.0 to the
>> set of rdma-only ip addresses for the device in question.  This prevents
>> incoming connect requests to the TCP ipaddresses from going up the
>> rdma stack.
> 
> I've only given this a high level review at this point, and while the 
> patch looks okay on first pass, is there a way to move some of this 
> functionality to either the rdma_cm or iw_cm?  I don't like the idea of 
> every iwarp driver having to implement address/listen list maintenance. 
>  I may have some ideas after re-examining it.
> 

Note: some rnic drivers might want to support this differently.  So 
maybe we don't want this in the iwcm yet until we see that more iwarp 
drivers need exactly the same functionality.


>> Implementation Details:
> 
> There are a couple of areas that I made a note to look at in more detail 
> (because I didn't understand everything that was happening), but I did 
> have one minor nit - most uses of list_del_init can just be list_del.
> 

fixed.

