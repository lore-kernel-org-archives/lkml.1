Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbXD0U5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbXD0U5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbXD0U5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:57:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43610 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbXD0U5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:57:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4632638D.2050004@s5r6.in-berlin.de>
Date: Fri, 27 Apr 2007 22:56:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Ben Collins <bcollins@debian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/30] Use menuconfig objects - IEEE1394
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote on 2007-04-10:
> Use menuconfigs instead of menus, so the whole menu can be disabled at        
> once instead of going through all options.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> Index: linux-2.6.21-rc5/drivers/ieee1394/Kconfig
> ===================================================================
> --- linux-2.6.21-rc5.orig/drivers/ieee1394/Kconfig
> +++ linux-2.6.21-rc5/drivers/ieee1394/Kconfig
> @@ -1,8 +1,6 @@
>  # -*- shell-script -*-
>  
> -menu "IEEE 1394 (FireWire) support"
> -
> -config IEEE1394
> +menuconfig IEEE1394
>  	tristate "IEEE 1394 (FireWire) support"
>  	depends on PCI || BROKEN
>  	select NET
[...]

Unless there are objections, I will merge it into my queue of IEEE 1394
updates for Linus.

(Personally, I still don't like it a lot. But perhaps only because I
have to untangle some -mm differences for this.)
-- 
Stefan Richter
-=====-=-=== -=-- ==-==
http://arcgraph.de/sr/
