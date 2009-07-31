Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZGaAWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZGaAWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZGaAWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:22:49 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:42187 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbZGaAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:22:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnABACfUcUqWZd+d/2dsb2JhbAAI0wyEFwWBSYgi
X-IronPort-AV: E=Sophos;i="4.43,298,1246804200"; 
   d="scan'208";a="425702459"
Message-ID: <4A723958.3030807@traverse.com.au>
Date: Fri, 31 Jul 2009 10:22:48 +1000
From: Nathan Williams <nathan@traverse.com.au>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
CC: linux-kernel@vger.kernel.org, chas@cmf.nrl.navy.mil,
       David.Woodhouse@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] [atm] fixed faulty check
References: <1248949491-20796-1-git-send-email-sgayda2@uiuc.edu>
In-Reply-To: <1248949491-20796-1-git-send-email-sgayda2@uiuc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090730-0, 30/07/2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stoyan Gaydarov wrote:
> This patche fixes a spelling error that has resulted from copy and pasting. The location of the error was found using a semantic patch but the semantic patch was not trying to find these errors. After looking things over it seemed logical that this change was needed. Please review it and then include the patch if it is in fact the correct change.
> 
> Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
> ---
>  drivers/atm/solos-pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
> index 9359613..307321b 100644
> --- a/drivers/atm/solos-pci.c
> +++ b/drivers/atm/solos-pci.c
> @@ -372,7 +372,7 @@ static int process_status(struct solos_card *card, int port, struct sk_buff *skb
>  	}
>  
>  	snr = next_string(skb);
> -	if (!str)
> +	if (!snr)
>  		return -EIO;
>  	attn = next_string(skb);
>  	if (!attn)

Thanks Stoyan.  Julia Lawall found this error a few days ago, which has been applied to net-next-2.6.
