Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZBSByR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZBSByR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZBSBx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:53:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54150
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbZBSBx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:53:57 -0500
Date: Wed, 18 Feb 2009 17:53:41 -0800 (PST)
Message-Id: <20090218.175341.142384927.davem@davemloft.net>
To: baranov@mercdev.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] niu: improve ethtool support for gigabit copper
 cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090217103852.48b110af.baranov@mercdev.com>
References: <20090217103852.48b110af.baranov@mercdev.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantin Baranov <baranov@mercdev.com>
Date: Tue, 17 Feb 2009 10:38:52 +0400

> Introduced support for link speed and duplex setting (ethtool -s),
> link advertising parameters and autonegotiation (ethtool -r):
> - struct niu_link_config: split advertising and autoneg
>   fields into active and target values (similar to speed
>   and duplex fields)
> - mii_init_common(): rewrite function to actually apply
>   requested niu_link_config parameters instead of providing
>   default initialization
> - link_status_1g(): move parsing of MII registers into
>   new link_status_mii() function (link_status_1g_rgmii()
>   could possibly use this new implementation too)
> - introduce simple nway_reset method
> - fix incorrect XMAC_CONFIG_MODE selection for 10Mbps case
> 
> Signed-off-by: Constantin Baranov <baranov@mercdev.com>

Looks good, patch applied, thanks.
