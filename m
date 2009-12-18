Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbZLRTgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbZLRTgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZLRTgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:33 -0500
Received: from kroah.org ([198.145.64.141]:47441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZLRTga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:30 -0500
Subject: patch staging-slicoss-no-need-to-check-pointer-in-debugfs_remove.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:52 -0800
In-Reply-To: <20091218075621.GA4514@coldcone>
Message-ID: <12611648323068@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: slicoss No need to check pointer in debugfs_remove()

to my gregkh-2.6 tree.  Its filename is

    staging-slicoss-no-need-to-check-pointer-in-debugfs_remove.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kirjanov@gmail.com  Fri Dec 18 10:33:42 2009
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
Date: Fri, 18 Dec 2009 10:56:21 +0300
Subject: staging: slicoss No need to check pointer in debugfs_remove()
To: gregkh@suse.de, liodot@gmail.com, charrer@alacritech.com
Cc: devel@linuxdriverproject.org
Message-ID: <20091218075621.GA4514@coldcone>
Content-Disposition: inline


No need to check pointer expicitly since it has been done in debugfs_remove()

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/staging/slicoss/slicoss.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3971,10 +3971,8 @@ static void slic_debug_adapter_create(st
 
 static void slic_debug_adapter_destroy(struct adapter *adapter)
 {
-	if (adapter->debugfs_entry) {
-		debugfs_remove(adapter->debugfs_entry);
-		adapter->debugfs_entry = NULL;
-	}
+	debugfs_remove(adapter->debugfs_entry);
+	adapter->debugfs_entry = NULL;
 }
 
 static void slic_debug_card_create(struct sliccard *card)

