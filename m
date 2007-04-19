Return-Path: <linux-kernel-owner+w=401wt.eu-S1766936AbXDSTDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766936AbXDSTDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766934AbXDSTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:03:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59986 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766933AbXDSTDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:03:44 -0400
Message-ID: <4627BD0E.4070705@garzik.org>
Date: Thu, 19 Apr 2007 15:03:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.21 1/2] cxgb3 - Fix low memory conditions
References: <20070417180630.17050.15974.stgit@localhost.localdomain>
In-Reply-To: <20070417180630.17050.15974.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Reuse the incoming skb when a clientless abort req is recieved.
> 
> The release of RDMA connections HW resources might be deferred in
> low memory situations. 
> Ensure that no further activity is passed up to the RDMA driver
> for these connections.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/cxgb3_defs.h    |    5 ++-
>  drivers/net/cxgb3/cxgb3_offload.c |   69 +++++++++++++++++++++++++++----------
>  2 files changed, 55 insertions(+), 19 deletions(-)

applied 1-2


