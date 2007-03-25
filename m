Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXCYVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXCYVW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 17:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbXCYVW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 17:22:58 -0400
Received: from lazybastard.de ([212.112.238.170]:48849 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658AbXCYVW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 17:22:57 -0400
Date: Sun, 25 Mar 2007 22:40:26 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] block2mtd_paramline[] mustn't be __initdata
Message-ID: <20070325204026.GB19691@lazybastard.org>
References: <20070325145805.GH16477@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070325145805.GH16477@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 March 2007 16:58:05 +0200, Adrian Bunk wrote:
> 
> block2mtd_paramline[] is used in the non-__init block2mtd_setup()
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-By: Jörn Engel <joern@lazybastard.org>

Adrian, can you put me on Cc: next time?

> ---
> --- linux-2.6.21-rc4-mm1/drivers/mtd/devices/block2mtd.c.old	2007-03-25 15:56:10.000000000 +0200
> +++ linux-2.6.21-rc4-mm1/drivers/mtd/devices/block2mtd.c	2007-03-25 15:56:31.000000000 +0200
> @@ -423,7 +423,7 @@
>  
>  #ifndef MODULE
>  static int block2mtd_init_called = 0;
> -static __initdata char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
> +static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
>  #endif

Jörn

-- 
Das Aufregende am Schreiben ist es, eine Ordnung zu schaffen, wo
vorher keine existiert hat.
-- Doris Lessing
