Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXJ0FyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXJ0FyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXJ0FyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:54:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46809
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbXJ0FyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:54:12 -0400
Date: Fri, 26 Oct 2007 22:54:12 -0700 (PDT)
Message-Id: <20071026.225412.52199506.davem@davemloft.net>
To: bunk@kernel.org
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] net/ipv{4,6}/esp{4,6}.c must #include
 <linux/scatterlist.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071027023448.GP30533@stusta.de>
References: <20071027023448.GP30533@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sat, 27 Oct 2007 04:34:48 +0200

> This patch fixes the following compile errors in some configurations:
> 
> <--  snip  -->
> 
> ...
>   CC      net/ipv4/esp4.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/esp4.c: In function 'esp_output':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/esp4.c:113: error: implicit declaration of function 'sg_init_table'
> make[3]: *** [net/ipv4/esp4.o] Error 1
> ...
> /home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv6/esp6.c: In function 'esp6_output':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv6/esp6.c:112: error: implicit declaration of function 'sg_init_table'
> make[3]: *** [net/ipv6/esp6.o] Error 1
> 
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
