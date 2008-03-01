Return-Path: <linux-kernel-owner+w=401wt.eu-S1763208AbYCAQ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763208AbYCAQ1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763150AbYCAQYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:24:19 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39195 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763025AbYCAQYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:24:17 -0500
Date: Sat, 1 Mar 2008 18:22:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] feature-removal-schedule.txt: remove the NCR53C9x entry
Message-ID: <20080301162246.GW25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the driver is removed we should also remove the entry in 
Documentation/feature-removal-schedule.txt

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6d7882f6e844eaf6551b3a3708e01d1784916435 foobar
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c1d1fd0..a4530f0 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -19,15 +19,6 @@ Who:	Pavel Machek <pavel@suse.cz>
 
 ---------------------------
 
-What:	old NCR53C9x driver
-When:	October 2007
-Why:	Replaced by the much better esp_scsi driver.  Actual low-level
-	driver can be ported over almost trivially.
-Who:	David Miller <davem@davemloft.net>
-	Christoph Hellwig <hch@lst.de>
-
----------------------------
-
 What:	Video4Linux API 1 ioctls and video_decoder.h from Video devices.
 When:	December 2008
 Files:	include/linux/video_decoder.h include/linux/videodev.h

