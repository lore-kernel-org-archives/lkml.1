Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYGDMta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYGDMta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYGDMtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:49:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56348 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYGDMtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:49:17 -0400
Message-ID: <486E1C49.7030503@garzik.org>
Date: Fri, 04 Jul 2008 08:49:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Subject: Re: [NET-NEXT PATCH 07/18] igb: add NAPI Rx queue support
References: <20080627175921.22428.52767.stgit@localhost.localdomain> <20080627180035.22428.73511.stgit@localhost.localdomain>
In-Reply-To: <20080627180035.22428.73511.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher wrote:
> From: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> 
> Update the NAPI implementation to use the new napi_struct infrstructure.
> This removes the need of multiple net_device structs to implement a
> multiqueue NAPI.
> 
> Signed-off-by: PJ Waskiewicz <peter.p.waskiewicz.jr.@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> 
>  drivers/net/igb/igb.h      |    2 +
>  drivers/net/igb/igb_main.c |  148 ++++++++++++++++++--------------------------
>  2 files changed, 61 insertions(+), 89 deletions(-)

applied 1-7 to net-next


