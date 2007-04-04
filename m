Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbXDDXXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbXDDXXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXDDXXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:23:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37186 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbXDDXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:23:28 -0400
Date: Wed, 4 Apr 2007 16:16:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Keith Owens <kaos@ocs.com.au>,
       Len Brown <lenb@kernel.org>, Adam Belay <ambx1@neo.rr.com>,
       Matthieu CASTET <castet.matthieu@free.fr>,
       Jean Tourrilhes <jt@hpl.hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ville Syrjala <syrjala@sci.fi>,
       Russell King <rmk+serial@arm.linux.org.uk>,
       linux-serial@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] smsc-ircc2: add PNP support
Message-Id: <20070404161650.e05049e4.randy.dunlap@oracle.com>
In-Reply-To: <20070404224609.042716000@ldl.fc.hp.com>
References: <20070404224536.337573000@ldl.fc.hp.com>
	<20070404224609.042716000@ldl.fc.hp.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 16:45:40 -0600 Bjorn Helgaas wrote:

> Index: w/drivers/net/irda/smsc-ircc2.c
> ===================================================================
> --- w.orig/drivers/net/irda/smsc-ircc2.c	2007-04-04 13:45:18.000000000 -0600
> +++ w/drivers/net/irda/smsc-ircc2.c	2007-04-04 13:47:00.000000000 -0600
> @@ -79,6 +79,10 @@
>  MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
>  MODULE_LICENSE("GPL");
>  
> +static int smsc_nopnp;
> +module_param_named(nopnp, smsc_nopnp, bool, 0);
> +MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");

Document this parameter (like you did "legacy_serial.force" in the
other patch -- thanks).

>  #define DMA_INVAL 255
>  static int ircc_dma = DMA_INVAL;
>  module_param(ircc_dma, int, 0);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
