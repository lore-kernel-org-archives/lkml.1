Return-Path: <linux-kernel-owner+w=401wt.eu-S1945990AbXBCODO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945990AbXBCODO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 09:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945995AbXBCODO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 09:03:14 -0500
Received: from elch.in-berlin.de ([192.109.42.5]:53977 "EHLO elch.in-berlin.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945990AbXBCODN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 09:03:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45C49137.2060103@s5r6.in-berlin.de>
Date: Sat, 03 Feb 2007 14:42:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pieter Palmers <pieterp@joow.be>, Dan Dennedy <dan@dennedy.org>,
       linux1394-devel@lists.sourceforge.net
Subject: which header for local_irq_save? (was Re: [PATCH update] ieee1394:
 cycle timer read extension for raw1394/libraw1394)
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de> <45BB2D67.7030608@joow.be> <45BB4A33.4070206@s5r6.in-berlin.de> <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
In-Reply-To: <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> --- linux.orig/drivers/ieee1394/ieee1394_core.c	2007-01-27 14:07:00.000000000 +0100
> +++ linux/drivers/ieee1394/ieee1394_core.c	2007-02-03 13:47:33.000000000 +0100
> @@ -33,6 +33,9 @@
>  #include <linux/skbuff.h>
>  #include <linux/suspend.h>
>  #include <linux/kthread.h>
> +#include <linux/irqflags.h>
> +#include <linux/preempt.h>
> +#include <linux/time.h>
>  
>  #include <asm/byteorder.h>
>  

Is <linux/irqflags.h> the correct header for local_irq_save/
local_irq_restore? It seems to be <asm/system.h> under Linux 2.6.16 but
I'm not sure about later kernels.
-- 
Stefan Richter
-=====-=-=== --=- ---==
http://arcgraph.de/sr/
