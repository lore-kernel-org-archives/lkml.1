Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXBYTsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXBYTsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbXBYTst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:48:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34403 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbXBYTsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:48:47 -0500
Message-ID: <45E1E810.2000706@garzik.org>
Date: Sun, 25 Feb 2007 14:48:32 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] cxgb3 - FW version update
References: <20070225004401.20831.3292.stgit@localhost.localdomain> <1172431719.4717.8.camel@stevo-laptop>
In-Reply-To: <1172431719.4717.8.camel@stevo-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> Hey Divy,
> 
> You missed a printk change.  Here is an updated patch.
> 
> ------------
> 
> Update FW version to 3.2
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
> 
>  drivers/net/cxgb3/t3_hw.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
> index 365a7f5..08a6295 100644
> --- a/drivers/net/cxgb3/t3_hw.c
> +++ b/drivers/net/cxgb3/t3_hw.c
> @@ -884,11 +884,11 @@ int t3_check_fw_version(struct adapter *
>  	major = G_FW_VERSION_MAJOR(vers);
>  	minor = G_FW_VERSION_MINOR(vers);
>  
> -	if (type == FW_VERSION_T3 && major == 3 && minor == 1)
> +	if (type == FW_VERSION_T3 && major == 3 && minor == 2)
>  		return 0;
>  
>  	CH_ERR(adapter, "found wrong FW version(%u.%u), "
> -	       "driver needs version 3.1\n", major, minor);
> +	       "driver needs version 3.2\n", major, minor);

I would rather fix the code to use constants, and thus avoid this 
problem ever happening again.

	Jeff



