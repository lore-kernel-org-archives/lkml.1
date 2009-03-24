Return-Path: <linux-kernel-owner+w=401wt.eu-S1764025AbZCXUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764025AbZCXUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbZCXUUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:20:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53662
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753951AbZCXUUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:20:12 -0400
Date: Tue, 24 Mar 2009 13:19:59 -0700 (PDT)
Message-Id: <20090324.131959.233890622.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: yanok@emcraft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/dnet.c needs <linux/io.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0903242042060.19647@anakin>
References: <Pine.LNX.4.64.0903242042060.19647@anakin>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 24 Mar 2009 20:43:25 +0100 (CET)

> On m68k:
> | drivers/net/dnet.c: In function 'dnet_readw_mac':
> | drivers/net/dnet.c:36: error: implicit declaration of function 'writel'
> | drivers/net/dnet.c:43: error: implicit declaration of function 'readl'
> | drivers/net/dnet.c: In function 'dnet_probe':
> | drivers/net/dnet.c:873: error: implicit declaration of function 'ioremap'
> | drivers/net/dnet.c:873: warning: assignment makes pointer from integer without a cast
> | drivers/net/dnet.c:939: error: implicit declaration of function 'iounmap'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks!
