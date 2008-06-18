Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYFREEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYFREEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 00:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYFREEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 00:04:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38047 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYFREEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 00:04:07 -0400
Message-ID: <48588933.2060605@garzik.org>
Date: Wed, 18 Jun 2008 00:04:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH] [UPDATED] ixgbe: add LRO support
References: <20080613183716.9641.33945.stgit@localhost.localdomain>
In-Reply-To: <20080613183716.9641.33945.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher wrote:
> From: Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>
> 
> Support for in-kernel LRO with the ability to enable/disable via ethtool
> based on comments from Ben Hutchings and Randy Dunlap.
> 
> Signed-off-by: Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> ---
> 
>  drivers/net/Kconfig               |    3 +
>  drivers/net/ixgbe/ixgbe.h         |    9 +++
>  drivers/net/ixgbe/ixgbe_ethtool.c |   11 ++++
>  drivers/net/ixgbe/ixgbe_main.c    |  111 ++++++++++++++++++++++++++++++-------
>  4 files changed, 112 insertions(+), 22 deletions(-)


I take that back.

This patch has a bunch of checkpatch problems, and it doesn't even 
compile, so it obviously was not tested:

drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_receive_skb’:
drivers/net/ixgbe/ixgbe_main.c:416: error: implicit declaration of 
function ‘vlan_nw_accel_receive_skb’

