Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbYDAL7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbYDAL7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbYDAL67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:58:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48048 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYDAL66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:58:58 -0400
Date: Tue, 1 Apr 2008 12:55:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: firmware_sample_driver.c: fix coding style
Message-ID: <20080401105546.GA10714@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style in firmware_sample_driver...

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/firmware_class/firmware_sample_driver.c b/Documentation/firmware_class/firmware_sample_driver.c
index 6865cbe..600cdd9 100644
--- a/Documentation/firmware_class/firmware_sample_driver.c
+++ b/Documentation/firmware_class/firmware_sample_driver.c
@@ -34,8 +34,7 @@ static void sample_probe_default(void)
         const struct firmware *fw_entry;
 	printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted :)\n");
 
-        if(request_firmware(&fw_entry, "sample_driver_fw", &ghost_device)!=0)
-	{
+        if (request_firmware(&fw_entry, "sample_driver_fw", &ghost_device)!=0) {
 		printk(KERN_ERR
 		       "firmware_sample_driver: Firmware not available\n");
 		return;
@@ -56,8 +55,7 @@ static void sample_probe_specific(void)
 
 	printk(KERN_INFO "firmware_sample_driver: a ghost device got inserted :)\n");
 
-        if(request_firmware(NULL, "sample_driver_fw", &ghost_device)!=0)
-	{
+        if (request_firmware(NULL, "sample_driver_fw", &ghost_device)!=0) {
 		printk(KERN_ERR
 		       "firmware_sample_driver: Firmware load failed\n");
 		return;
@@ -70,7 +68,7 @@ static void sample_probe_specific(void)
 }
 static void sample_probe_async_cont(const struct firmware *fw, void *context)
 {
-	if(!fw){
+	if (!fw) {
 		printk(KERN_ERR
 		       "firmware_sample_driver: firmware load failed\n");
 		return;
@@ -88,9 +86,8 @@ static void sample_probe_async(void)
 					 "sample_driver_fw", &ghost_device,
 					 "my device pointer",
 					 sample_probe_async_cont);
-	if(error){
-		printk(KERN_ERR 
-		       "firmware_sample_driver:"
+	if (error) {
+		printk(KERN_ERR "firmware_sample_driver:"
 		       " request_firmware_nowait failed\n");
 	}
 }
@@ -105,6 +102,7 @@ static int sample_init(void)
 	sample_probe_async();
 	return 0;
 }
+
 static void __exit sample_exit(void)
 {
 }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
