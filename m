Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYKMCSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYKMCSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYKMCSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:18:08 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:17189 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752095AbYKMCSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:18:07 -0500
Date: Wed, 12 Nov 2008 19:18:03 -0700
From: dougthompson@xmission.com
To: dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: fix mpc85xx and add mpc8536 mpc8560
Message-ID: <491b8e5b.uSc1E4+nIKbPbwoT%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>

All other compatibles that are uniquely identifying the processor use
a prefix of the form fsl,mpc85...'.  We add support for it so we
can deprecate the older 'fsl,85...' that was improperly used here.

Additionally added mpc8536 & mpc8560 to the compatible lists.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Acked-by: Dave Jiang <djiang@mvista.com>
---

This patch is based on Nate's 8572 patch.

 drivers/edac/mpc85xx_edac.c |   74 ++++++++++++++++++------------------------
 1 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 63bdc47..184799a 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -630,27 +630,22 @@ static int mpc85xx_l2_err_remove(struct of_device *op)
 }

 static struct of_device_id mpc85xx_l2_err_of_match[] = {
-	{
-	 .compatible = "fsl,8540-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8541-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8544-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8548-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8555-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,8568-l2-cache-controller",
-	 },
-	{
-	 .compatible = "fsl,mpc8572-l2-cache-controller",
-	 },
+/* deprecate the fsl,85.. forms in the future, 2.6.30? */
+	{ .compatible = "fsl,8540-l2-cache-controller", },
+	{ .compatible = "fsl,8541-l2-cache-controller", },
+	{ .compatible = "fsl,8544-l2-cache-controller", },
+	{ .compatible = "fsl,8548-l2-cache-controller", },
+	{ .compatible = "fsl,8555-l2-cache-controller", },
+	{ .compatible = "fsl,8568-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8536-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8540-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8541-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8544-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8548-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8555-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
 	{},
 };

@@ -967,27 +962,22 @@ static int mpc85xx_mc_err_remove(struct of_device *op)
 }

 static struct of_device_id mpc85xx_mc_err_of_match[] = {
-	{
-	 .compatible = "fsl,8540-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8541-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8544-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8548-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8555-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,8568-memory-controller",
-	 },
-	{
-	 .compatible = "fsl,mpc8572-memory-controller",
-	 },
+/* deprecate the fsl,85.. forms in the future, 2.6.30? */
+	{ .compatible = "fsl,8540-memory-controller", },
+	{ .compatible = "fsl,8541-memory-controller", },
+	{ .compatible = "fsl,8544-memory-controller", },
+	{ .compatible = "fsl,8548-memory-controller", },
+	{ .compatible = "fsl,8555-memory-controller", },
+	{ .compatible = "fsl,8568-memory-controller", },
+	{ .compatible = "fsl,mpc8536-memory-controller", },
+	{ .compatible = "fsl,mpc8540-memory-controller", },
+	{ .compatible = "fsl,mpc8541-memory-controller", },
+	{ .compatible = "fsl,mpc8544-memory-controller", },
+	{ .compatible = "fsl,mpc8548-memory-controller", },
+	{ .compatible = "fsl,mpc8555-memory-controller", },
+	{ .compatible = "fsl,mpc8560-memory-controller", },
+	{ .compatible = "fsl,mpc8568-memory-controller", },
+	{ .compatible = "fsl,mpc8572-memory-controller", },
 	{},
 };

