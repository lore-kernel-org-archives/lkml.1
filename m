Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055Ab0CMA2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:28:05 -0500
Received: from kroah.org ([198.145.64.141]:32846 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935047Ab0CMAVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:06 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001514.586476887@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben-linux@fluff.org>,
       <linux-mmc@vger.kernel.org>
Subject: [patch 108/123] s3cmci: s3cmci_card_present: Use no_detect to decide whether there is a card detect pin
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit dc2ed552804f3a2ae41c0ffe4bc09879ec8f7396 upstream.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/s3cmci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1179,7 +1179,7 @@ static int s3cmci_card_present(struct mm
 	struct s3c24xx_mci_pdata *pdata = host->pdata;
 	int ret;
 
-	if (pdata->gpio_detect == 0)
+	if (pdata->no_detect)
 		return -ENOSYS;
 
 	ret = gpio_get_value(pdata->gpio_detect) ? 0 : 1;


