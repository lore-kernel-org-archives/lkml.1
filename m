Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYFYDJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYFYDJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYFYDJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:09:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48120 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714AbYFYDJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:09:37 -0400
Message-ID: <4861B6ED.1010903@garzik.org>
Date: Tue, 24 Jun 2008 23:09:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH] [UPDATED] ixgbe: add LRO support
References: <20080618222715.7333.59688.stgit@localhost.localdomain>
In-Reply-To: <20080618222715.7333.59688.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
> based on comments from Ben Hutchings.
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

applied


