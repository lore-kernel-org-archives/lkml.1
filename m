Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbYA2VbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbYA2VbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYA2VbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:31:05 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:57010 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008AbYA2VbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:31:04 -0500
Message-ID: <479F9B12.8010207@steeleye.com>
Date: Tue, 29 Jan 2008 16:30:58 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] NBD: raise max number of nbd devices to 1024
Content-Type: multipart/mixed;
 boundary="------------000507010409070702000105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000507010409070702000105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The limit was 128. This changes it to 1024.

--
Paul

--------------000507010409070702000105
Content-Type: text/x-patch;
 name="nbd_max_nbd_1024.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nbd_max_nbd_1024.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

--- ./include/linux/nbd.h.TIMEOUT	2007-08-22 13:18:12.000000000 -0400
+++ ./include/linux/nbd.h	2008-01-29 14:35:17.000000000 -0500
@@ -35,7 +35,7 @@ enum {
 };
 
 #define nbd_cmd(req) ((req)->cmd[0])
-#define MAX_NBD 128
+#define MAX_NBD 1024
 
 /* userspace doesn't need the nbd_device structure */
 #ifdef __KERNEL__

--------------000507010409070702000105--
