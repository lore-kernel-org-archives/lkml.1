Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab0CKSFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:05:42 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:43634 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659Ab0CKSFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:05:24 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 15/37] drivers/mmc: use .dev.of_node instead of .node in
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
Date: Thu, 11 Mar 2010 11:05:10 -0700
Message-ID: <20100311180510.4824.40934.stgit@angua>
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

 drivers/mmc/host/sdhci-of-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-core.c b/drivers/mmc/host/sdhci-of-core.c
index 55e3313..dfe5cea 100644
--- a/drivers/mmc/host/sdhci-of-core.c
+++ b/drivers/mmc/host/sdhci-of-core.c
@@ -118,7 +118,7 @@ static bool __devinit sdhci_of_wp_inverted(struct device_node *np)
 static int __devinit sdhci_of_probe(struct of_device *ofdev,
 				 const struct of_device_id *match)
 {
-	struct device_node *np = ofdev->node;
+	struct device_node *np = ofdev->dev.of_node;
 	struct sdhci_of_data *sdhci_of_data = match->data;
 	struct sdhci_host *host;
 	struct sdhci_of_host *of_host;

