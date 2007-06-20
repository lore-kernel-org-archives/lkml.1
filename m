Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXFTXRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXFTXRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXFTXRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:17:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45646 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbXFTXRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:17:15 -0400
Message-ID: <4679B579.6040208@garzik.org>
Date: Wed, 20 Jun 2007 19:17:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/5] cxgb3 - fix skb->dev dereference
References: <20070530170128.22789.3485.stgit@localhost.localdomain>
In-Reply-To: <20070530170128.22789.3485.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> eth_type_trans() now sets skb->dev. 
> References to skb->dev should happen after it is called.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/net/cxgb3/sge.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied 1-5 to #upstream-fixes (2.6.22)


