Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXBFRRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXBFRRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932999AbXBFRRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:17:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:13330 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbXBFRRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:17:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,291,1167638400"; 
   d="scan'208"; a="177923677:sNHT5212313680"
Message-ID: <45C8B808.3080908@intel.com>
Date: Tue, 06 Feb 2007 09:16:56 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: cramerj@intel.com, john.ronciak@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] e1000: Use ARRAY_SIZE macro when appropriate
References: <20070205165546.GE3896@Ahmed>
In-Reply-To: <20070205165546.GE3896@Ahmed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2007 17:16:57.0468 (UTC) FILETIME=[9B0F33C0:01C74A12]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmed S. Darwish wrote:
> Hi,
> 
> A patch to use ARRAY_SIZE macro already defined in kernel.h.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: Auke Kok <auke-jan.h.kok@intel.com>

Cheers,

Auke

> ---
> Patch is compile tested.
> 
> diff --git a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
> index fb96c87..d21706e 100644
> --- a/drivers/net/e1000/e1000_ethtool.c
> +++ b/drivers/net/e1000/e1000_ethtool.c
> @@ -746,7 +746,7 @@ err_setup:
>  	uint32_t pat, value;                                                   \
>  	uint32_t test[] =                                                      \
>  		{0x5A5A5A5A, 0xA5A5A5A5, 0x00000000, 0xFFFFFFFF};              \
> -	for (pat = 0; pat < sizeof(test)/sizeof(test[0]); pat++) {              \
> +	for (pat = 0; pat < ARRAY_SIZE(test); pat++) {              \
>  		E1000_WRITE_REG(&adapter->hw, R, (test[pat] & W));             \
>  		value = E1000_READ_REG(&adapter->hw, R);                       \
>  		if (value != (test[pat] & W & M)) {                             \
> 
