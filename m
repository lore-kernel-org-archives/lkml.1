Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbXJNGi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbXJNGi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 02:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbXJNGit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 02:38:49 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:53584 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbXJNGit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 02:38:49 -0400
Message-ID: <4711B958.8020401@linux.vnet.ibm.com>
Date: Sun, 14 Oct 2007 12:08:16 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>, rdreier@cisco.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] typo in ibm_newemac/rgmii.c
References: <20071014045012.GS8181@ftp.linux.org.uk>
In-Reply-To: <20071014045012.GS8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/drivers/net/ibm_newemac/rgmii.c b/drivers/net/ibm_newemac/rgmii.c
> index bcd7fc6..3f57d6c 100644
> --- a/drivers/net/ibm_newemac/rgmii.c
> +++ b/drivers/net/ibm_newemac/rgmii.c
> @@ -251,7 +251,7 @@ static int __devinit rgmii_probe(struct of_device *ofdev,
>  	}
> 
>  	/* Check for RGMII type */
> -	if (device_is_compatible(ofdev->node, "ibm,rgmii-axon"))
> +	if (of_device_is_compatible(ofdev->node, "ibm,rgmii-axon"))
>  		dev->type = RGMII_AXON;
>  	else
>  		dev->type = RGMII_STANDARD;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hi,

The same patch was submitted on http://lkml.org/lkml/2007/10/13/8

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
