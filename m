Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbYA3Vx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbYA3Vx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbYA3Vwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:52:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:62788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760528AbYA3Vwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:52:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,280,1199692800"; 
   d="scan'208";a="510743488"
Message-ID: <47A0F18B.109@intel.com>
Date: Wed, 30 Jan 2008 13:52:11 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeff Garzik <jeff@garzik.org>, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, john.ronciak@intel.com,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make e1000_dump_eeprom() static
References: <20080130200245.GZ29368@does.not.exist>
In-Reply-To: <20080130200245.GZ29368@does.not.exist>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2008 21:52:52.0770 (UTC) FILETIME=[76AC5020:01C8638A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global e1000_dump_eeprom() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

yes, thanks, I'll push it to Jeff.

Auke

> 
> ---
> b5fd924a1388d4aaa94cf05e42e317c2b1fb5748 
> diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
> index 7f5b2ae..8a6645b 100644
> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -820,7 +820,7 @@ e1000_reset(struct e1000_adapter *adapter)
>  /**
>   *  Dump the eeprom for users having checksum issues
>   **/
> -void e1000_dump_eeprom(struct e1000_adapter *adapter)
> +static void e1000_dump_eeprom(struct e1000_adapter *adapter)
>  {
>  	struct net_device *netdev = adapter->netdev;
>  	struct ethtool_eeprom eeprom;
> 

