Return-Path: <linux-kernel-owner+w=401wt.eu-S2992860AbXCCBRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992860AbXCCBRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992856AbXCCBRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:17:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55539 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992861AbXCCBRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:17:19 -0500
Message-ID: <45E8CC9C.3080607@pobox.com>
Date: Fri, 02 Mar 2007 20:17:16 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dale Farnsworth <dale@farnsworth.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/2] mv643xx_eth: move mac_addr inside mv643xx_eth_platform_data
References: <20070301233148.GA19550@xyzzy.farnsworth.org>
In-Reply-To: <20070301233148.GA19550@xyzzy.farnsworth.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dale Farnsworth wrote:
> The information contained within platform_data should be self-contained.
> Replace the pointer to a MAC address with the actual MAC address in
> struct mv643xx_eth_platform_data.
> 
> Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
> 
> ---
> 
> Replaced explicit mac address comparison with a call to is_valid_ether_addr(),
> as suggested by Stephen Hemminger <shemminger@linux-foundation.org>.
> 
>  arch/mips/momentum/jaguar_atx/platform.c |   20 ++++----------------
>  arch/mips/momentum/ocelot_3/platform.c   |   20 ++++----------------
>  arch/mips/momentum/ocelot_c/platform.c   |   12 ++----------
>  drivers/net/mv643xx_eth.c                |    2 +-
>  include/linux/mv643xx.h                  |    2 +-
>  5 files changed, 12 insertions(+), 44 deletions(-)

applied


