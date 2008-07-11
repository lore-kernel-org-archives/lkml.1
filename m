Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYGKFW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYGKFW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYGKFWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:22:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49679 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYGKFWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:22:17 -0400
Message-ID: <4876EE04.9090208@garzik.org>
Date: Fri, 11 Jul 2008 01:22:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Mitch Williams <mitch.a.williams@intel.com>,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [RESEND NET-NEXT PATCH 08/20] igb: Introduce multiple TX queues
 with	infrastructure
References: <20080708220046.1518.88457.stgit@localhost.localdomain> <20080708220619.1518.52996.stgit@localhost.localdomain>
In-Reply-To: <20080708220619.1518.52996.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
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
>  drivers/net/igb/igb.h      |    7 +-
>  drivers/net/igb/igb_main.c |  160 ++++++++++++++++++++++++++++++--------------
>  2 files changed, 114 insertions(+), 53 deletions(-)

applied 8-20


