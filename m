Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab0CKSPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:15:03 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63703 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933685Ab0CKSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:05:32 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 18/37] drivers/pcmcia: use .dev.of_node instead of .node in
	struct of_device
To: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Date: Thu, 11 Mar 2010 11:05:27 -0700
Message-ID: <20100311180527.4824.74325.stgit@angua>
In-Reply-To: <20100311174830.4824.19820.stgit@angua>
References: <20100311174830.4824.19820.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.node is being removed

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/pcmcia/electra_cf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 89cfddc..a4d821f 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -184,7 +184,7 @@ static int __devinit electra_cf_probe(struct of_device *ofdev,
 				      const struct of_device_id *match)
 {
 	struct device *device = &ofdev->dev;
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct electra_cf_socket   *cf;
 	struct resource mem, io;
 	int status;

