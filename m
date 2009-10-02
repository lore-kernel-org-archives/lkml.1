Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZJBXHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZJBXHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 19:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbZJBXHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 19:07:11 -0400
Received: from the.earth.li ([217.147.81.2]:57331 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbZJBXHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 19:07:10 -0400
X-Greylist: delayed 1548 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 19:07:10 EDT
Date: Fri, 2 Oct 2009 23:41:25 +0100
From: Jonathan McDowell <noodles@earth.li>
To: "Govindraj.R" <govindraj.raja@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
Message-ID: <20091002224124.GY1133@earth.li>
References: <65168.192.168.10.89.1253788033.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65168.192.168.10.89.1253788033.squirrel@dbdmail.itg.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 03:57:13PM +0530, Govindraj.R wrote:
> From: Govindraj R <govindraj.raja@ti.com>
> 
> This patch adds support for OMAP3430-HIGH SPEED UART Controller.
> 
> Signed-off-by:	Govindraj R <govindraj.raja@ti.com>
> Reviewed-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> ---
 
> +config SERIAL_OMAP
> +	bool "OMAP serial port support"
> +	depends on ARM && ARCH_OMAP
> +	select SERIAL_CORE
> +	help
> +	If you have a machine based on an Texas Instruments OMAP CPU you
> +	can enable its onboard serial ports by enabling this option.

If it's OMAP3 hardware then should the "depends on" be ARCH_OMAP3 ||
ARCH_OMAP4, rather than allowing it for OMAP1 + 2 as well?

J.

-- 
Revd. Jonathan McDowell, ULC | If they can't take a joke....fuck 'em.
