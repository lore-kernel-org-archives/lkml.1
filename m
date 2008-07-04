Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYGDMnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYGDMnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYGDMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:43:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54578 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbYGDMnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:43:14 -0400
Message-ID: <486E1ADE.50706@garzik.org>
Date: Fri, 04 Jul 2008 08:43:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Subject: Re: [NET-NEXT PATCH 08/18] igb: Introduce multiple TX queues with
 infrastructure
References: <20080627175921.22428.52767.stgit@localhost.localdomain> <20080627180044.22428.21729.stgit@localhost.localdomain>
In-Reply-To: <20080627180044.22428.21729.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher wrote:
> From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> 
> This code adds multiple Tx queue infrastructure much like we
> previously did in ixgbe. The MSI-X vector mapping is the bulk of
> the change.
> 
> IAM can now be safely enabled and we've verified that it does
> work correctly. We can also eliminate the tx ring lock.
> 
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> ---
> 
>  drivers/net/igb/igb.h      |    6 +-
>  drivers/net/igb/igb_main.c |  160 ++++++++++++++++++++++++++++++--------------
>  2 files changed, 113 insertions(+), 53 deletions(-)

presumably this should wait for david to finish his multi-TX stuff?


