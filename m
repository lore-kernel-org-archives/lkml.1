Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbXLEBX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbXLEBX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 20:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXLEBXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 20:23:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:36899 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXLEBXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 20:23:16 -0500
Date: Wed, 5 Dec 2007 04:22:58 +0300
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [NET] phy/fixed.c: rework to not duplicate PHY
 layer functionality
Message-ID: <20071205042258.486f5738@kernel.crashing.org>
In-Reply-To: <4755B395.6070104@garzik.org>
References: <20071126142906.19642.45540.stgit@localhost.localdomain>
	<4755B395.6070104@garzik.org>
X-Mailer: Claws Mail 3.1.0cvs26 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 15:07:49 -0500
Jeff Garzik wrote:

> Vitaly Bordug wrote:
> > With that patch fixed.c now fully emulates MDIO bus, thus no need
> > to duplicate PHY layer functionality. That, in turn, drastically
> > simplifies the code, and drops down line count.
> > 
> > As an additional bonus, now there is no need to register MDIO bus
> > for each PHY, all emulated PHYs placed on the platform fixed MDIO
> > bus. There is also no more need to pre-allocate PHYs via .config
> > option, this is all now handled dynamically.
> > 
> > p.s. Don't even try to understand patch content! Better: apply patch
> > and look into resulting drivers/net/phy/fixed.c.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> 
> ACK, I presume this will go via the ppc tree?
> 

Yes, I'll add your ack in next respin and will ask Paul to consider it,
if you don't mind.

-- 
Sincerely, Vitaly
