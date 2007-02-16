Return-Path: <linux-kernel-owner+w=401wt.eu-S1946157AbXBPWAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946157AbXBPWAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946154AbXBPWAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:00:10 -0500
Received: from khc.piap.pl ([195.187.100.11]:36135 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946153AbXBPWAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:00:07 -0500
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/wan/pc300too.c: pci_module_init to pci_register_driver
References: <20070214004022.4455.49724.sendpatchset@thinktank.campus.ltu.se>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 16 Feb 2007 23:00:02 +0100
In-Reply-To: <20070214004022.4455.49724.sendpatchset@thinktank.campus.ltu.se> (Richard Knutsson's message of "Wed, 14 Feb 2007 01:40:21 +0100 (MET)")
Message-ID: <m3d549pxul.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson <ricknu-0@student.ltu.se> writes:

> Convert pci_module_init() to pci_register_driver().
>
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>

Ack.

> --- a/drivers/net/wan/pc300too.c
> +++ b/drivers/net/wan/pc300too.c
> @@ -542,7 +542,7 @@ static int __init pc300_init_module(void)
>  
>  	CLOCK_BASE = use_crystal_clock ? 24576000 : pci_clock_freq;
>  
> -	return pci_module_init(&pc300_pci_driver);
> +	return pci_register_driver(&pc300_pci_driver);
>  }
>  
>  
>

-- 
Krzysztof Halasa
