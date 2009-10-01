Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZJAXXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZJAXXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZJAXXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:23:20 -0400
Received: from kroah.org ([198.145.64.141]:39664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbZJAXXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:23:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:18:05 2009
Message-Id: <20091001231805.021733475@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:16:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cord Walter <qord@cwalter.net>, Komuro <komurojun-mbn@nifty.com>,
       "David S. Miller" <davem@davemloft.net>,
       Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: [patch 4/9] pcnet_cs: Fix misuse of the equality operator.
References: <20091001231633.719696398@mini.kroah.org>
Content-Disposition: inline; filename=pcnet_cs-fix-misuse-of-the-equality-operator.patch
In-Reply-To: <20091001231938.GA29593@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cord Walter <qord@cwalter.net>

commit a9d3a146923d374b945aa388dc884df69564a818 upstream.

Signed-off-by: Cord Walter <qord@cwalter.net>
Signed-off-by: Komuro <komurojun-mbn@nifty.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pcmcia/pcnet_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -591,7 +591,7 @@ static int pcnet_config(struct pcmcia_de
     }
 
     if ((link->conf.ConfigBase == 0x03c0)
-	&& (link->manf_id == 0x149) && (link->card_id = 0xc1ab)) {
+	&& (link->manf_id == 0x149) && (link->card_id == 0xc1ab)) {
 	printk(KERN_INFO "pcnet_cs: this is an AX88190 card!\n");
 	printk(KERN_INFO "pcnet_cs: use axnet_cs instead.\n");
 	goto failed;


