Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYKSTSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYKSTSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYKSTSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:18:13 -0500
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:57654 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbYKSTSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:18:12 -0500
Subject: Re: linux-next: Tree for November 19 (mtd build error)
From: Ben Hutchings <bhutchings@solarflare.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-net-drivers@solarflare.com
In-Reply-To: <492463A1.3000306@oracle.com>
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
	 <20081119105321.477e618a.randy.dunlap@oracle.com>
	 <1227121104.27728.618.camel@macbook.infradead.org>
	 <492463A1.3000306@oracle.com>
Content-Type: text/plain; charset=UTF-8
Organization: Solarflare Communications
Date: Wed, 19 Nov 2008 19:18:07 +0000
Message-Id: <1227122287.3052.7.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
X-Originating-Smarthost02-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 11:06 -0800, Randy Dunlap wrote:
> David Woodhouse wrote:
> > On Wed, 2008-11-19 at 10:53 -0800, Randy Dunlap wrote:
> >> On Wed, 19 Nov 2008 17:59:17 +1100 Stephen Rothwell wrote:
> >>
> >> (.text+0x104879): undefined reference to `add_mtd_device'
> >> (.text+0x1048e1): undefined reference to `del_mtd_device'
> >> mtd.c:(.text+0x104999): undefined reference to `mtd_erase_callback'
> >>
> >>
> >> config attached.
> > 
> > CONFIG_SFC_MTD=y
> > 
> > What's that?
> 
> drivers/net/sfc/Kconfig:
> 
> config SFC_MTD
> 	bool "Solarflare Solarstorm SFC4000 flash MTD support"
> 	depends on SFC && MTD
> 	default y
> 	help
> 	  This exposes the on-board flash memory as an MTD device (e.g.
>           /dev/mtd1).  This makes it possible to upload new boot code
>           to the NIC.
> 
> 
> sfc people added to cc.

﻿Please use the address linux-net-drivers@solarflare.com, as listed in
MAINTAINERS.﻿  There are several of us working on the driver, and they
no longer include Michael Brown.

David Woodhouse wrote:
> ﻿Sounds like this was built-in while CONFIG_MTD=m

So does the dependency need to be something like
"depends on SFC && MTD && !(SFC=y && MTD=m)"?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

