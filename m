Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZDFJU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZDFJU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZDFJU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:20:26 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:43505 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbZDFJUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:20:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sVP5MyGW0F+Cq5fggJBOPWFdvZVktdBjxQ0Oh9ynmBhVmWHJbTFIFT+Oxx387E6HF0
         UmVlyYMcqt0WcmfIbdPnuasP4HEMOBXd/pD50r52PNOxNe7moLB2fm8pPNf/ZBWB0cpj
         9O432MX+X+c6VR/jRRipc9hHJTTwpunDFbRjE=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 6/8] Staging: comedi: remove dupilcated #include
Date: Mon,  6 Apr 2009 17:20:17 +0800
Message-Id: <1239009617-3480-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dupilcated #include in drivers/staging/comedi/drivers/8253.h.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/staging/comedi/drivers/8253.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8253.h b/drivers/staging/comedi/drivers/8253.h
index 08a11a5..c7537a6 100644
--- a/drivers/staging/comedi/drivers/8253.h
+++ b/drivers/staging/comedi/drivers/8253.h
@@ -24,11 +24,7 @@
 #ifndef _8253_H
 #define _8253_H
 
-#ifndef CMDTEST
-#include "../comedi.h"
-#else
 #include "../comedi.h"
-#endif
 
 #define i8253_cascade_ns_to_timer i8253_cascade_ns_to_timer_2div
 
-- 
1.6.1.3

