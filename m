Return-Path: <linux-kernel-owner+w=401wt.eu-S1764629AbXHWTp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764629AbXHWTp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762849AbXHWTps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:45:48 -0400
Received: from smtp.opengridcomputing.com ([71.42.183.126]:51548 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755568AbXHWTpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:45:47 -0400
X-Greylist: delayed 1228 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 15:45:47 EDT
Message-ID: <46CDDF1E.1010408@opengridcomputing.com>
Date: Thu, 23 Aug 2007 14:25:18 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: divy@chelsio.com, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23] cxgb3 - Fix dev->priv usage
References: <20070813193303.15321.49171.stgit@speedy5> <20070813.135811.06543390.davem@davemloft.net>
In-Reply-To: <20070813.135811.06543390.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch doesn't seem to have gone in yet????

Steve.


David Miller wrote:
> From: Divy Le Ray <divy@chelsio.com>
> Date: Mon, 13 Aug 2007 12:33:04 -0700
> 
>> From: Divy Le Ray <divy@chelsio.com>
>>
>> cxgb3 used netdev_priv() and dev->priv for different purposes.
>> In 2.6.23, netdev_priv() == dev->priv, cxgb3 needs a fix.
>> This patch is a partial backport of Dave Miller's changes in the 
>> net-2.6.24 git branch. 
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> 
> Thank you for doing this backport.
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
