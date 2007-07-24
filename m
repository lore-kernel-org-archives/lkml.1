Return-Path: <linux-kernel-owner+w=401wt.eu-S933105AbXGXMjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbXGXMjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbXGXMjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:39:03 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:34602 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446AbXGXMjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:39:00 -0400
Message-ID: <46A5EC2D.9070504@billgatliff.com>
Date: Tue, 24 Jul 2007 07:10:21 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: pxa timer code broken for non-CONFIG_GENERIC_CLOCKEVENTS
References: <20070724042947.GM1678@pengutronix.de> <20070724073330.GA14217@flint.arm.linux.org.uk>
In-Reply-To: <20070724073330.GA14217@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> You'll find a fix for this on linux-arm-kernel since yesterday morning.
>   

I accidentally left this out of the patch that made it into the database 
(and someone else caught my mistake and posted it on l-a-k yesterday):


=== modified file 'arch/arm/Kconfig'
--- linux-2.6.22-arm-pxaarch/arm/Kconfig        2007-05-30 13:30:58 +0000
+++ /linux-2.6.22-arm-pxa-clockevents/arch/arm/Kconfig  2007-07-12 
20:04:51 +0000
@@ -331,6 +331,7 @@
        select ARCH_MTD_XIP
        select GENERIC_GPIO
        select GENERIC_TIME
+       select GENERIC_CLOCKEVENTS
        help
          Support for Intel's PXA2XX processor line.


Sorry!


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

