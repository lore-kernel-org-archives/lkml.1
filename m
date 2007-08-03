Return-Path: <linux-kernel-owner+w=401wt.eu-S1763874AbXHCU3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763874AbXHCU3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXHCU3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:29:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:31365 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbXHCU3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:29:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,218,1183359600"; 
   d="scan'208";a="276494466"
Message-ID: <46B39030.7030009@intel.com>
Date: Fri, 03 Aug 2007 13:29:36 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Andrew Gallatin <gallatin@myri.com>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] lro: eHEA example how to use LRO
References: <200708031441.26841.ossthema@de.ibm.com>
In-Reply-To: <200708031441.26841.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2007 20:29:36.0845 (UTC) FILETIME=[0283A7D0:01C7D60D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> This patch shows how the generic LRO interface is used for SKB mode
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> 
> ---
>  drivers/net/Kconfig             |    1 +
>  drivers/net/ehea/ehea.h         |    9 ++++-
>  drivers/net/ehea/ehea_ethtool.c |   15 +++++++
>  drivers/net/ehea/ehea_main.c    |   84 +++++++++++++++++++++++++++++++++++---
>  4 files changed, 101 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index f8a602c..fec4004 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig

<snip>

> +module_param(use_lro, int, 0);

Have you looked at my generic lro get/set patch that I posted this week? this 
adds a useless module parameter while ethtool has all the structure already to 
accomodate setting lro on/off.

Auke
