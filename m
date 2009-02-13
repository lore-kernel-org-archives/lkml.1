Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbZBMKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbZBMKGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbZBMKGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:06:07 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:30691 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZBMKGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nc+R3KBf7jFrqlLb1cy253AGV6F85/7EVwlpQEZuOE/dEyS7JgTT67aRXlKq9UCrfy
         ILw/fYyeVGyVnNowtX1jQDWsJEGKHDTrr5jugNMHhnlBycsWX2VDdEWCuocB6z46dU1w
         MMiTioRhAMs8WdaPEN5IUv1BWltR+tXCbLTBM=
Message-ID: <49954606.9080204@gmail.com>
Date: Fri, 13 Feb 2009 11:05:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/isdn/hardware/mISDN: fix sparse warnings: make
 symbols static
References: <20090212192810.7401.70271.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090212192810.7401.70271.stgit@vmbox.hanneseder.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2009 08:28 PM, Hannes Eder wrote:
> diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> index f0e14df..2bb85c4 100644
> --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> @@ -56,8 +56,8 @@ static const char *hfcpci_revision = "2.0";
>  static int HFC_cnt;
>  static uint debug;
>  static uint poll, tics;
> -struct timer_list hfc_tl;
> -u32	hfc_jiffies;
> +static struct timer_list hfc_tl;
> +static u32 hfc_jiffies;

Please also fix the hfc_jiffies type (ulong). (As a separate patch.)
