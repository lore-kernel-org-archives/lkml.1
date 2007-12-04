Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbXLDUIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbXLDUIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXLDUHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:07:53 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53422 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXLDUHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:07:52 -0500
Message-ID: <4755B395.6070104@garzik.org>
Date: Tue, 04 Dec 2007 15:07:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [NET] phy/fixed.c: rework to not duplicate PHY layer
 functionality
References: <20071126142906.19642.45540.stgit@localhost.localdomain>
In-Reply-To: <20071126142906.19642.45540.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Bordug wrote:
> With that patch fixed.c now fully emulates MDIO bus, thus no need
> to duplicate PHY layer functionality. That, in turn, drastically
> simplifies the code, and drops down line count.
> 
> As an additional bonus, now there is no need to register MDIO bus
> for each PHY, all emulated PHYs placed on the platform fixed MDIO bus.
> There is also no more need to pre-allocate PHYs via .config option,
> this is all now handled dynamically.
> 
> p.s. Don't even try to understand patch content! Better: apply patch
> and look into resulting drivers/net/phy/fixed.c.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

ACK, I presume this will go via the ppc tree?


