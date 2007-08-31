Return-Path: <linux-kernel-owner+w=401wt.eu-S965024AbXHaLlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbXHaLlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbXHaLlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:41:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46741 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbXHaLlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:41:10 -0400
Message-ID: <46D7FE52.8020807@garzik.org>
Date: Fri, 31 Aug 2007 07:41:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Divy Le Ray <divy@chelsio.com>
CC: rdreier@cisco.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.23 1/2] cxgb3 - Fix dev->priv usage
References: <20070830021547.21475.62560.stgit@speedy5>
In-Reply-To: <20070830021547.21475.62560.stgit@speedy5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> cxgb3 used netdev_priv() and dev->priv for different purposes.
> In 2.6.23, netdev_priv() == dev->priv, cxgb3 needs a fix.
> This patch is a partial backport of Dave Miller's changes in the 
> net-2.6.24 git branch. 
> 
> Without this fix, cxgb3 crashes on 2.6.23.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
> 
>  drivers/infiniband/hw/cxgb3/cxio_hal.c |    2 -
>  drivers/net/cxgb3/adapter.h            |    2 +
>  drivers/net/cxgb3/cxgb3_main.c         |  126 ++++++++++++++++++--------------
>  drivers/net/cxgb3/cxgb3_offload.c      |   16 +++-
>  drivers/net/cxgb3/cxgb3_offload.h      |    2 +
>  drivers/net/cxgb3/sge.c                |   23 ++++--
>  drivers/net/cxgb3/t3cdev.h             |    3 -
>  7 files changed, 105 insertions(+), 69 deletions(-)

applied 1-2


