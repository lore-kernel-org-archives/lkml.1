Return-Path: <linux-kernel-owner+w=401wt.eu-S934012AbXGZQtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbXGZQtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765763AbXGZQtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:49:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49257 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934182AbXGZQtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:49:12 -0400
Message-ID: <46A8D084.5030407@garzik.org>
Date: Thu, 26 Jul 2007 12:49:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb3 gfp_t annotations
References: <E1IE6J5-0005Mn-NU@ZenIV.linux.org.uk>
In-Reply-To: <E1IE6J5-0005Mn-NU@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/cxgb3/cxgb3_offload.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/cxgb3/cxgb3_offload.c b/drivers/net/cxgb3/cxgb3_offload.c
> index ebcf35e..e620ed4 100644
> --- a/drivers/net/cxgb3/cxgb3_offload.c
> +++ b/drivers/net/cxgb3/cxgb3_offload.c
> @@ -699,7 +699,7 @@ static int do_cr(struct t3cdev *dev, struct sk_buff *skb)
>   * the buffer.
>   */
>  static struct sk_buff *cxgb3_get_cpl_reply_skb(struct sk_buff *skb, size_t len,
> -					       int gfp)
> +					       gfp_t gfp)

ACK


