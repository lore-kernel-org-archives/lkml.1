Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZHETCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZHETCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZHETCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:02:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57920
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbZHETCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:02:53 -0400
Date: Wed, 05 Aug 2009 12:03:02 -0700 (PDT)
Message-Id: <20090805.120302.204538944.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, isdn@linux-pingi.de, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -next] isdn: fix netjet build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090805092635.6e6df57e.randy.dunlap@oracle.com>
References: <20090805172337.b0688db1.sfr@canb.auug.org.au>
	<20090805092635.6e6df57e.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 5 Aug 2009 09:26:35 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix netjet driver link errors when ISDN_I4L is not enabled:
> 
> drivers/built-in.o: In function `mode_tiger':
> netjet.c:(.text+0x325dc8): undefined reference to `isdnhdlc_rcv_init'
> netjet.c:(.text+0x325dd5): undefined reference to `isdnhdlc_out_init'
> drivers/built-in.o: In function `fill_dma':
> netjet.c:(.text+0x325fb6): undefined reference to `isdnhdlc_encode'
> drivers/built-in.o: In function `read_dma':
> netjet.c:(.text+0x32631a): undefined reference to `isdnhdlc_decode'
> drivers/built-in.o: In function `nj_irq':
> netjet.c:(.text+0x326e01): undefined reference to `isdnhdlc_encode'
> 
> or move isdnhdlc.c to some other sub-dir..
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks Randy.

Karsten, let me know if you want me to apply this directly to
net-next-2.6 or if you want to fix it differently or send it
with other changes you have pending.

Thanks!
