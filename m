Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYIMXOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYIMXOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 19:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYIMXOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 19:14:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41867 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbYIMXOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 19:14:04 -0400
Message-ID: <48CC4933.2060507@garzik.org>
Date: Sat, 13 Sep 2008 19:13:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hannes Hering <hannes.hering@gmx.de>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Subject: Re: [PATCH 2/2] ehea: Enable DLPAR memory remove
References: <200809051638.22160.hannes.hering@gmx.de>
In-Reply-To: <200809051638.22160.hannes.hering@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Hering wrote:
> This patch adds the capability flag to the capability list for dynamic LPAR
> memory remove to enable this feature.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>
> ---
> 
> diff -Nurp -X dontdiff linux-2.6.27-rc5/drivers/net/ehea/ehea.h patched_kernel/drivers/net/ehea/ehea.h
> --- linux-2.6.27-rc5/drivers/net/ehea/ehea.h	2008-08-29 00:52:02.000000000 +0200
> +++ patched_kernel/drivers/net/ehea/ehea.h	2008-09-05 15:33:12.000000000 +0200
> @@ -40,13 +40,13 @@
>  #include <asm/io.h>
>  
>  #define DRV_NAME	"ehea"
> -#define DRV_VERSION	"EHEA_0092"
> +#define DRV_VERSION	"EHEA_0093"
>  
>  /* eHEA capability flags */
>  #define DLPAR_PORT_ADD_REM 1
>  #define DLPAR_MEM_ADD      2
>  #define DLPAR_MEM_REM      4
> -#define EHEA_CAPABILITIES  (DLPAR_PORT_ADD_REM | DLPAR_MEM_ADD)
> +#define EHEA_CAPABILITIES  (DLPAR_PORT_ADD_REM | DLPAR_MEM_ADD | DLPAR_MEM_REM)

applied


