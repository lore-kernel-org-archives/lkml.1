Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbYEES3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbYEES3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760557AbYEES0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:26:37 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:32890 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760552AbYEES0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:26:36 -0400
Date: Mon, 5 May 2008 21:25:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make pnp_add_card_id() static
Message-ID: <20080505182529.GP17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_add_card_id() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/pnp/base.h |    1 -
 drivers/pnp/card.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

8a8949ff2a589ecf6eddf3dfd8f58edb7c46a657 diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 4fe7c58..fd82496 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -14,7 +14,6 @@ struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 
 int pnp_add_card(struct pnp_card *card);
-struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id);
 void pnp_remove_card(struct pnp_card *card);
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
index a762a41..8617766 100644
--- a/drivers/pnp/card.c
+++ b/drivers/pnp/card.c
@@ -101,7 +101,7 @@ static int card_probe(struct pnp_card *card, struct pnp_card_driver *drv)
  * @id: pointer to a pnp_id structure
  * @card: pointer to the desired card
  */
-struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id)
+static struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id)
 {
 	struct pnp_id *dev_id, *ptr;
 

