Return-Path: <linux-kernel-owner+w=401wt.eu-S1161846AbXECLQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161846AbXECLQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXECLQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:16:32 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3491 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXECLQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:16:31 -0400
Date: Thu, 3 May 2007 12:16:14 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       Sascha Hauer <s.hauer@pengutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dead CONFIG_ variables:   drivers/video/
Message-ID: <20070503111613.GD12018@flint.arm.linux.org.uk>
Mail-Followup-To: "Robert P. J. Day" <rpjday@mindspring.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0705030638270.380@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705030638270.380@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 06:40:03AM -0400, Robert P. J. Day wrote:
> $ ../dead_config.sh drivers/video
> ========== MACH_MX1FS2 ==========
> drivers/video/imxfb.c:410:#ifndef CONFIG_MACH_MX1FS2
> arch/arm/tools/mach-types:486:mx1fs2                    MACH_MX1FS2             MX1FS2                  470
> ========== MACH_PIMX1 ==========
> drivers/video/imxfb.c:404:#ifndef CONFIG_MACH_PIMX1
> arch/arm/tools/mach-types:678:pimx1                     MACH_PIMX1              PIMX1                   664

Sascha, any comments on these?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
