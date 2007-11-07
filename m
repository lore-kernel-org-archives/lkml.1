Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbXKGILJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbXKGILJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbXKGIKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:10:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46758
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756608AbXKGIKx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:10:53 -0500
Date: Wed, 07 Nov 2007 00:10:45 -0800 (PST)
Message-Id: <20071107.001045.90391662.davem@davemloft.net>
To: bunk@kernel.org
Cc: toralf.foerster@gmx.de, dbrownell@users.sourceforge.net, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6 patch] let USB_USBNET always select MII
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071101222524.GB7227@stusta.de>
References: <200711012024.57412.toralf.foerster@gmx.de>
	<20071101222524.GB7227@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Thu, 1 Nov 2007 23:25:24 +0100

> All this USB_USBNET_MII trickery is simply not worth it considering how 
> few code it saves.
> 
> As a side effect, this also fixes the following compile error reported 
> by Toralf Förster:
> 
> <--  snip  -->
> 
> ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `usbnet_set_settings':
> (.text+0xf1876): undefined reference to `mii_ethtool_sset'
> drivers/built-in.o: In function `usbnet_get_settings':
> (.text+0xf1836): undefined reference to `mii_ethtool_gset'
> drivers/built-in.o: In function `usbnet_get_link':
> (.text+0xf18d6): undefined reference to `mii_link_ok'
> drivers/built-in.o: In function `usbnet_nway_reset':
> (.text+0xf18f6): undefined reference to `mii_nway_restart'
> make: *** [.tmp_vmlinux1] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.

