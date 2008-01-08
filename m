Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYAHIpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYAHIpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbYAHIp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:45:28 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:42405 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbYAHIp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:45:28 -0500
Date: Tue, 8 Jan 2008 11:45:20 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH -mm 3/4] hvcs: fixup container_of() usage
Message-ID: <20080108084520.GC6209@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, fold into
gregkh-driver-kobject-convert-hvcs-to-use-kref-not-kobject.patch
----------------------------------------------------------------------
[PATCH -mm 3/4] hvcs: fixup container_of() usage 

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/char/hvcs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -304,7 +304,7 @@ struct hvcs_struct {
 };
 
 /* Required to back map a kref to its containing object */
-#define from_kref(kref) container_of(kref, struct hvcs_struct, kref)
+#define from_kref(k) container_of(k, struct hvcs_struct, kref)
 
 static LIST_HEAD(hvcs_structs);
 static DEFINE_SPINLOCK(hvcs_structs_lock);

