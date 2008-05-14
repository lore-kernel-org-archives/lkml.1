Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbYENWa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbYENWa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYENWaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:30:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44562
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbYENWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:30:09 -0400
Date: Wed, 14 May 2008 15:30:03 -0700 (PDT)
Message-Id: <20080514.153003.77372633.davem@davemloft.net>
To: bunk@kernel.org
Cc: graf.yang@analog.com, cooloney@kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6 patch] irnet_irda.c must #include <asm/unaligned.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080514202709.GB21795@cs181133002.pp.htv.fi>
References: <20080514202709.GB21795@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4EMUVEB021607

From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 14 May 2008 23:27:09 +0300

> This patch fixes the following compile error caused by
> commit 332223831e86b2e17b48b4afafad07d8e3b73861
> (irda: Fix a misalign access issue. (v2)):
> 
> <--  snip  -->
> 
> ...
>   CC      net/irda/irnet/irnet_irda.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/net/irda/irnet/irnet_irda.c: In function â€˜irnet_discovery_indicationâ€™:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/net/irda/irnet/irnet_irda.c:1676: error: implicit declaration of function â€˜get_unalignedâ€™
> make[4]: *** [net/irda/irnet/irnet_irda.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks a lot Adrian.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
