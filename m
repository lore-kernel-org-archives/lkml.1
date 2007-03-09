Return-Path: <linux-kernel-owner+w=401wt.eu-S1767386AbXCIQq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767386AbXCIQq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767389AbXCIQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:46:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57686 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767386AbXCIQq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:46:57 -0500
Message-ID: <45F18F7C.3030801@garzik.org>
Date: Fri, 09 Mar 2007 11:46:52 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Auke Kok <auke-jan.h.kok@intel.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, john.ronciak@intel.com,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH 1/3] e1000: FIX: be ready for incoming irq at pci_request_irq
References: <20070306165721.27434.23796.stgit@localhost.localdomain>
In-Reply-To: <20070306165721.27434.23796.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Auke Kok wrote:
> From: Auke Kok <auke-jan.h.kok@intel.com>
> 
> DEBUG_SHIRQ code exposed that e1000 was not ready for incoming interrupts
> after having called pci_request_irq. This obviously requires us to finish
> our software setup which assigns the irq handler before we request the
> irq.
> 
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> ---
> 
>  drivers/net/e1000/e1000_main.c |   66 +++++++++++++++++++++++++++-------------
>  1 files changed, 45 insertions(+), 21 deletions(-)

All these do indeed look like fixes to me.  But they look like low 
priority fixes that would need some public testing behind them, and it's 
pretty late in the 2.6.21-rc game.

I'll merge them into an e1000-fixes branch for now (and propagates 
through #ALL to akpm's -mm).  If replies to this email indicate we 
really should push these upstream for 2.6.21-rc, it will be easy enough 
to do so via #e1000-fixes.

	Jeff



