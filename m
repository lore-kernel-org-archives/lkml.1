Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYBPR1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYBPR1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYBPR06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:26:58 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:21027 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbYBPR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:26:56 -0500
Date: Sat, 16 Feb 2008 09:26:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] ide: add ide-4drives host driver
Message-Id: <20080216092635.987f002f.randy.dunlap@oracle.com>
In-Reply-To: <20080216163911.10174.58246.sendpatchset@localhost.localdomain>
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
	<20080216163911.10174.58246.sendpatchset@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 17:39:11 +0100 Bartlomiej Zolnierkiewicz wrote:

> CONFIG_BLK_DEV_4DRIVES deserves its own host driver:
> 
> * Add drivers/ide/legacy/ide-4drives.c and move "4drives" support there.
> 
> * Add ide-4drives.o in the link order after all other legacy host
>   drivers enabled by "ide0=" options (they all are mutually exclusive).
> 
> * Make ide-4drives host driver probe itself for IDE devices instead of
>   indirectly depending on ide_generic host driver.
> 
> * Add "probe" module parameter to ide-4drives and update documentation.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  Documentation/ide.txt            |    5 ++--
>  drivers/ide/Kconfig              |    4 +--
>  drivers/ide/ide.c                |   15 ++----------
>  drivers/ide/legacy/Makefile      |    1 
>  drivers/ide/legacy/ide-4drives.c |   46 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 55 insertions(+), 16 deletions(-)
> 
> Index: b/Documentation/ide.txt
> ===================================================================
> --- a/Documentation/ide.txt
> +++ b/Documentation/ide.txt
> @@ -242,8 +242,6 @@ Summary of ide driver parameters for ker
>  			  both the respective primary and secondary channel
>  			  to take effect.
>  
> - "idex=four"		: four drives on idex and ide(x^1) share same ports
> -			
>   "idex=reset"		: reset interface after probe
>  
>   "idex=ata66"		: informs the interface that it has an 80c cable
> @@ -276,6 +274,9 @@ Also for legacy CMD640 host driver (cmd6
>  kernel paremeter to enable probing for VLB version of the chipset (PCI ones
>  are detected automatically).
>  
> +You also need to use "probe" kernel paramater for ide-4drives driver

                                       parameter

> +(support for IDE generic chipset with four drives on one port).
> +

---
~Randy
