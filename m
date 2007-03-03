Return-Path: <linux-kernel-owner+w=401wt.eu-S2992788AbXCCANd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992788AbXCCANd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992786AbXCCANd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:13:33 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55020 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992785AbXCCANc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:13:32 -0500
Message-ID: <45E8BDA7.3070800@garzik.org>
Date: Fri, 02 Mar 2007 19:13:27 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata Kconfig: Update the various experimentality levels
References: <20070302150512.281af8d3@lxorguk.ukuu.org.uk>
In-Reply-To: <20070302150512.281af8d3@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/Kconfig linux-2.6.21-rc2/drivers/ata/Kconfig
> --- linux.vanilla-2.6.21-rc2/drivers/ata/Kconfig	2007-03-01 13:36:03.000000000 +0000
> +++ linux-2.6.21-rc2/drivers/ata/Kconfig	2007-03-02 13:30:50.535164824 +0000
> @@ -184,7 +184,7 @@
>  	  If unsure, say N.
>  
>  config PATA_AMD
> -	tristate "AMD/NVidia PATA support (Experimental)"
> +	tristate "AMD/NVidia PATA support"
>  	depends on PCI
>  	help
>  	  This option enables support for the AMD and NVidia PATA
> @@ -273,7 +283,7 @@
>  	  If unsure, say N.
>  
>  config PATA_HPT366
> -	tristate "HPT 366/368 PATA support (Very Experimental)"
> +	tristate "HPT 366/368 PATA support (Experimental)"
>  	depends on PCI && EXPERIMENTAL

ACK the changes you've presented, but please do resend combined with a 
patch that updates the CONFIG_EXPERIMENTAL dependencies at the same time


