Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZFSXxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZFSXxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZFSXxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:53:01 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:40572 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZFSXxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ehsz+TvM+ZZoYCqhU85DVJYX0nrKQdYQYtcCeUmpI3nTf+91KYd9n5iWDndTO0u0Sj
         YWNh5OrW0bkCh9TVCdksRS7DebkEnIrc4fHYzsr7hHVxNHt/P5E2iUNqLk64jgTaShQW
         X+rQ6i7efFTC5Zy1kOTzEBVEKuTMjtKljmj2Y=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: comedi: jr3_pci.c: add required includes
Date: Sat, 20 Jun 2009 03:52:47 +0400
Message-Id: <1245455567-18938-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build errors:
jr3_pci.c:739: error: 'jiffies' undeclared
jr3_pci.c:748: error: implicit declaration of function 'msecs_to_jiffies'
jr3_pci.c:763: error: implicit declaration of function 'add_timer'
jr3_pci.c:790: error: implicit declaration of function 'init_timer'
jr3_pci.c:951: error: implicit declaration of function 'del_timer_sync'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/comedi/drivers/jr3_pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index baf83c6..e3c3adc 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -45,6 +45,8 @@ Devices: [JR3] PCI force sensor board (jr3_pci)
 #include <linux/delay.h>
 #include <linux/ctype.h>
 #include <linux/firmware.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
 #include "comedi_pci.h"
 #include "jr3_pci.h"
 
-- 
1.6.3.1

