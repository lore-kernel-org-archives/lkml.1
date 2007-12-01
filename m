Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXLAWRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXLAWRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 17:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbXLAWQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 17:16:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:40175 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbXLAWQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 17:16:56 -0500
Date: Sun, 2 Dec 2007 01:16:40 +0300
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [NET] phy/fixed.c: rework to not duplicate PHY
 layer functionality
Message-ID: <20071202011640.3f64ed4d@kernel.crashing.org>
In-Reply-To: <4751D958.6060500@garzik.org>
References: <20071126142906.19642.45540.stgit@localhost.localdomain>
	<4751D958.6060500@garzik.org>
X-Mailer: Claws Mail 3.1.0cvs26 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2007 16:59:52 -0500
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
> what's the context of this patchset?  2.6.25?
> 
Fine with it.

> it's late for 2.6.24-rc, IMO.
> 
> Do I have the latest version (sent Nov 26 @ 9:29am)?
yes, that's it.

-- 
Sincerely, Vitaly
