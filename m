Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbYA3Vwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbYA3Vwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYA3Vw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:52:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:54895 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYA3Vw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:52:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,280,1199692800"; 
   d="scan'208";a="510743229"
Message-ID: <47A0F171.6030106@intel.com>
Date: Wed, 30 Jan 2008 13:51:45 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Joe Perches <joe@perches.com>, Jeff Garzik <jeff@garzik.org>,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       john.ronciak@intel.com, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] e1000e/ethtool.c: make a function static
References: <20080130200243.GY29368@does.not.exist>
In-Reply-To: <20080130200243.GY29368@does.not.exist>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2008 21:52:26.0738 (UTC) FILETIME=[67282520:01C8638A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global reg_pattern_test_array() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

stephen hemminger already pointed this out to me... I'll certainly push this
upstream, thanks Adrian!

Auke


> 
> ---
> ed72e457f06311390d9a9e51a00c904939466aff 
> diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
> index 6d9c27f..a2034cf 100644
> --- a/drivers/net/e1000e/ethtool.c
> +++ b/drivers/net/e1000e/ethtool.c
> @@ -690,8 +690,8 @@ err_setup:
>  	return err;
>  }
>  
> -bool reg_pattern_test_array(struct e1000_adapter *adapter, u64 *data,
> -			    int reg, int offset, u32 mask, u32 write)
> +static bool reg_pattern_test_array(struct e1000_adapter *adapter, u64 *data,
> +				   int reg, int offset, u32 mask, u32 write)
>  {
>  	int i;
>  	u32 read;
> 

