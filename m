Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab0CJPn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:43:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab0CJPnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:43:23 -0500
Message-ID: <4B97BCEA.1000101@redhat.com>
Date: Wed, 10 Mar 2010 10:38:18 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Tomas Dabasinskas <tomas.it@gmail.com>
CC: gregkh@suse.de, abraham.manu@gmail.com, davilla@4pi.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: crystalhd: fixed white spaces and brace coding
 in crystalhd_hw.c
References: <1268214661-12992-1-git-send-email-tomas.it@gmail.com>
In-Reply-To: <1268214661-12992-1-git-send-email-tomas.it@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 04:51 AM, Tomas Dabasinskas wrote:

 > This is a patch to the crystalhd_hw.c file that fixes up a white
 > space and brace warnings found by the checkpatch.pl tool
 >
 > Signed-off-by: Tomas Dabasinskas <tomas.it@gmail.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

Although, ultimately, I'm planning to replace all the BCMLOG bits anyway 
with dev_foo printk wrappers. Just haven't had time to yet.

--jarod


> ---
>   drivers/staging/crystalhd/crystalhd_hw.c |   29 ++++++++++++-----------------
>   1 files changed, 12 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
> index 01819d3..772da05 100644
> --- a/drivers/staging/crystalhd/crystalhd_hw.c
> +++ b/drivers/staging/crystalhd/crystalhd_hw.c
> @@ -431,7 +431,7 @@ static void crystalhd_hw_delete_ioqs(struct crystalhd_hw *hw)
>   	if (!hw)
>   		return;
>
> -	BCMLOG(BCMLOG_DBG, "Deleting IOQs \n");
> +	BCMLOG(BCMLOG_DBG, "Deleting IOQs\n");
>   	crystalhd_hw_delete_ioq(hw->adp, hw->tx_actq);
>   	crystalhd_hw_delete_ioq(hw->adp, hw->tx_freeq);
>   	crystalhd_hw_delete_ioq(hw->adp, hw->rx_actq);
...

-- 
Jarod Wilson
jarod@redhat.com
