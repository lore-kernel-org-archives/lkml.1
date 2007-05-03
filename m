Return-Path: <linux-kernel-owner+w=401wt.eu-S1031344AbXECOQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031344AbXECOQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031348AbXECOQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:16:53 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:55855 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031344AbXECOQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:16:52 -0400
Date: Thu, 3 May 2007 16:16:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dead CONFIG_ variables:   drivers/video/
Message-ID: <20070503141649.GB5107@localhost.localdomain>
References: <Pine.LNX.4.64.0705030638270.380@localhost.localdomain> <20070503111613.GD12018@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503111613.GD12018@flint.arm.linux.org.uk>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 16:11:38 up 1 day,  7:09,  2 users,  load average: 0.02, 0.07, 0.02
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 12:16:14PM +0100, Russell King wrote:
> On Thu, May 03, 2007 at 06:40:03AM -0400, Robert P. J. Day wrote:
> > $ ../dead_config.sh drivers/video
> > ========== MACH_MX1FS2 ==========
> > drivers/video/imxfb.c:410:#ifndef CONFIG_MACH_MX1FS2
> > arch/arm/tools/mach-types:486:mx1fs2                    MACH_MX1FS2             MX1FS2                  470

MX1FS2 is one of our development boards, this entry can be removed
(I haven't started this board for ages)

> > ========== MACH_PIMX1 ==========
> > drivers/video/imxfb.c:404:#ifndef CONFIG_MACH_PIMX1
> > arch/arm/tools/mach-types:678:pimx1                     MACH_PIMX1              PIMX1                   664

This is Pavels board. I think this can also be removed. The call to
imx_gpio_mode() can also be done in the board file. If we do so we
should cc Pavel.

Sascha

-- 
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de
