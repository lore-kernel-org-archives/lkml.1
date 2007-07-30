Return-Path: <linux-kernel-owner+w=401wt.eu-S967435AbXG3Qib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967435AbXG3Qib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967074AbXG3QiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:38:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:35451 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967008AbXG3QiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:38:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,199,1183359600"; 
   d="scan'208";a="256490653"
Message-ID: <46AE13D0.7060902@intel.com>
Date: Mon, 30 Jul 2007 09:37:36 -0700
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
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       Andrew Gallatin <gallatin@myri.com>
Subject: Re: [PATCH 3/4][RFC] ehea: LRO support
References: <200707301724.49829.ossthema@de.ibm.com>
In-Reply-To: <200707301724.49829.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2007 16:38:11.0215 (UTC) FILETIME=[0461A9F0:01C7D2C8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> Added LRO support using the "SKB aggregate" interface
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> 
> ---
>  drivers/net/ehea/ehea.h         |    9 ++++-
>  drivers/net/ehea/ehea_ethtool.c |   15 +++++++
>  drivers/net/ehea/ehea_main.c    |   82 +++++++++++++++++++++++++++++++++++---
>  3 files changed, 98 insertions(+), 8 deletions(-)

<snip>

> +module_param(use_lro, int, 0);
> +module_param(lro_max_aggr, int, 0);

this should obviously (and Stephen H. probably agrees) be implemented in ethtool 
instead, and opens up the question as to what changes we need to add to ethtool. ..

Auke
