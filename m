Return-Path: <linux-kernel-owner+w=401wt.eu-S941931AbXHNFqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941931AbXHNFqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940908AbXHNFnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:43:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46733 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942275AbXHNFng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:43:36 -0400
Message-ID: <46C14106.4080604@garzik.org>
Date: Tue, 14 Aug 2007 01:43:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 4/13] cxgb3 - use immediate data for offload Tx
References: <20070811062949.8076.42523.stgit@speedy5>
In-Reply-To: <20070811062949.8076.42523.stgit@speedy5>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Send small TX_DATA work requests as immediate data even when
> there are fragments.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/sge.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)

needs additional explanation.  don't just describe the new post-change 
behavior, describe why this change is needed.


