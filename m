Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYKSTIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYKSTIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYKSTIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:08:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYKSTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:08:45 -0500
Subject: Re: linux-next: Tree for November 19 (mtd build error)
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Michael Brown <mbrown@fensystems.co.uk>,
       Ben Hutchings <bhutchings@solarflare.com>
In-Reply-To: <492463A1.3000306@oracle.com>
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
	 <20081119105321.477e618a.randy.dunlap@oracle.com>
	 <1227121104.27728.618.camel@macbook.infradead.org>
	 <492463A1.3000306@oracle.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 19:08:37 +0000
Message-Id: <1227121717.27728.620.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 11:06 -0800, Randy Dunlap wrote:

> drivers/net/sfc/Kconfig:
> 
> config SFC_MTD
>         bool "Solarflare Solarstorm SFC4000 flash MTD support"
>         depends on SFC && MTD
>         default y
>         help
>           This exposes the on-board flash memory as an MTD device (e.g.
>           /dev/mtd1).  This makes it possible to upload new boot code
>           to the NIC.
> 
> 
> sfc people added to cc.

Sounds like this was built-in while CONFIG_MTD=m

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

