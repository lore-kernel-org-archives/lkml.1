Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYLIRFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYLIRFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYLIRFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:05:11 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:38659 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYLIRFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:05:09 -0500
X-Greylist: delayed 701 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 12:05:09 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nbGdGCXVwWrhW9F8pFj4sk2aGg1jVLobFZAfHr8MMYmlkDbbQceTGIVK2eBkOJD4my
         NDTcxQQv9NBImHrOSBtj7rVNFAGt79xQDKeVUdRSi7mkOOP6+wfL63gdnWaSLAvKy1MH
         +Fh9xosAhmDLWxfhiw7geGVFuoZwIigdA3bDw=
Message-ID: <493EA543.5010305@gmail.com>
Date: Tue, 09 Dec 2008 18:05:07 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: paul@paulbristow.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/33] drivers/block/floppy: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/block/floppy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cf29cc4..b49000c 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4140,7 +4140,7 @@ static ssize_t floppy_cmos_show(struct device *dev,
 	drive = p->id;
 	return sprintf(buf, "%X\n", UDP->cmos);
 }
-DEVICE_ATTR(cmos,S_IRUGO,floppy_cmos_show,NULL);
+static DEVICE_ATTR(cmos, S_IRUGO, floppy_cmos_show, NULL);
 
 static void floppy_device_release(struct device *dev)
 {

