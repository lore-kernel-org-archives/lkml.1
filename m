Return-Path: <linux-kernel-owner+w=401wt.eu-S934103AbXEERaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103AbXEERaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934104AbXEERaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:30:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38966 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934103AbXEERav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:30:51 -0400
Date: Sat, 5 May 2007 19:30:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] the OLPC laptop is not available for $100
Message-ID: <20070505173052.GH8975@stusta.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> 
> 
> - Added the git-battery tree to the -mm lineup (Anton Vorontsov
>   <cbou@mail.ru>).  It presently generates mysterious depmod error messages.
>...
> Changes since 2.6.21-rc7-mm2:
>...
>  git-battery.patch
>...
>  git trees
>...

The price might drop to $100 in a few years.

But currently, a more reasonable name might be "$175 laptop".

Let's simply call it "OLPC laptop" without any price tag.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/battery/Kconfig        |    2 +-
 drivers/battery/olpc_battery.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-mm1/drivers/battery/Kconfig.old	2007-05-05 19:22:18.000000000 +0200
+++ linux-2.6.21-mm1/drivers/battery/Kconfig	2007-05-05 19:20:02.000000000 +0200
@@ -34,6 +34,6 @@
 	tristate "One Laptop Per Child battery"
 	depends on BATTERY && X86_32
 	help
-	  Say Y to enable support for the battery on the $100 laptop.
+	  Say Y to enable support for the battery on the OLPC laptop.
 
 endmenu
--- linux-2.6.21-mm1/drivers/battery/olpc_battery.c.old	2007-05-05 19:22:42.000000000 +0200
+++ linux-2.6.21-mm1/drivers/battery/olpc_battery.c	2007-05-05 19:22:56.000000000 +0200
@@ -1,5 +1,5 @@
 /*
- * Battery driver for One Laptop Per Child ($100 laptop) board.
+ * Battery driver for One Laptop Per Child board.
  *
  *	Copyright © 2006  David Woodhouse <dwmw2@infradead.org>
  *

