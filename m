Return-Path: <linux-kernel-owner+w=401wt.eu-S936463AbYD1Pqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936463AbYD1Pqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964993AbYD1PkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:40:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59655 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986AbYD1PkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:40:10 -0400
Date: Mon, 28 Apr 2008 18:39:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] usb/storage/onetouch.c: make a function static
Message-ID: <20080428153937.GQ2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global onetouch_release_input() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/usb/storage/onetouch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

3bb10b5aab1aefed48029c92edd49f3362ab6311 diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
index dfd42fe..98b89ea 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -38,7 +38,7 @@
 #include "onetouch.h"
 #include "debug.h"
 
-void onetouch_release_input(void *onetouch_);
+static void onetouch_release_input(void *onetouch_);
 
 struct usb_onetouch {
 	char name[128];
@@ -223,7 +223,7 @@ int onetouch_connect_input(struct us_data *ss)
 	return error;
 }
 
-void onetouch_release_input(void *onetouch_)
+static void onetouch_release_input(void *onetouch_)
 {
 	struct usb_onetouch *onetouch = (struct usb_onetouch *) onetouch_;
 

