Return-Path: <linux-kernel-owner+w=401wt.eu-S1763302AbYHEUFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763302AbYHEUFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760061AbYHEUEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:04:54 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43328 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761585AbYHEUEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:04:53 -0400
Date: Tue, 5 Aug 2008 23:03:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] feature-removal-schedule.txt: remove the NCR53C9x entry
Message-ID: <20080805200330.GJ22895@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the driver is removed we should also remove the entry in 
Documentation/feature-removal-schedule.txt

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>

---

This patch has been sent on:
- 1 Mar 2008

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

