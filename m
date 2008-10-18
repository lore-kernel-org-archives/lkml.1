Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYJRDwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYJRDwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 23:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYJRDwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 23:52:17 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:37271 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYJRDwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 23:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=M0cQbVZgp+A/EChfnYz2lVM3Sdo/V0qBeghBORWAdK11JPGGZQvVgK7Xa7sBwTdGxv
         A85yZ3YKLo8HMBJZNbh4xrgypNsAXPKmz1MEZz2k0cjTtEUeTOdzFHbCeRPxxjXRxSFr
         svFiMnnqNjpAdR6+krALjUb+r4DT65KjIauQg=
Date: Sat, 18 Oct 2008 11:52:13 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Subject: staging: et131x: remove duplicated #include's
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081018113310.61AE.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include's in file(s) below,
 - drivers/staging/et131x/et1310_phy.c
      et1310_jagcore.h
      linux/delay.h
 - drivers/staging/et131x/et131x_debug.c
      et1310_jagcore.h
 - drivers/staging/et131x/et131x_initpci.c
      et1310_jagcore.h

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310
index 6c4fa54..9dd6dfd 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -84,7 +84,6 @@
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
 #include <linux/random.h>
-#include <linux/delay.h>

 #include "et1310_phy.h"
 #include "et1310_pm.h"
@@ -95,7 +94,6 @@
 #include "et131x_initpci.h"

 #include "et1310_address_map.h"
-#include "et1310_jagcore.h"
 #include "et1310_tx.h"
 #include "et1310_rx.h"
 #include "et1310_mac.h"

diff --git a/drivers/staging/et131x/et131x_debug.c b/drivers/staging/et131x/et13
index 9ee5bce..d1dd46e 100644
--- a/drivers/staging/et131x/et131x_debug.c
+++ b/drivers/staging/et131x/et131x_debug.c
@@ -97,7 +97,6 @@
 #include "et131x_isr.h"

 #include "et1310_address_map.h"
-#include "et1310_jagcore.h"
 #include "et1310_tx.h"
 #include "et1310_rx.h"
 #include "et1310_mac.h"

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et
index 4c6f171..a18c499 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -97,7 +97,6 @@
 #include "et131x_isr.h"

 #include "et1310_address_map.h"
-#include "et1310_jagcore.h"
 #include "et1310_tx.h"
 #include "et1310_rx.h"
 #include "et1310_mac.h"

