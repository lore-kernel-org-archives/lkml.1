Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZDFJVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZDFJVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZDFJUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:20:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:43505 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbZDFJUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tOoXtWP8jslbyAV+AuQQTciazRkhb8IVFArKHllw8GB+EpEhciDFmJR6OmP3fQTtqG
         WIgNMK+xpcpD9mpLJebvdesjgvbkUOdAQOF1c4N/LkPfpkQpTMZbvzV13xLYm4n8UG7V
         /0qq6ekkVeKlU7sWbsIegKVoOsrZqvsuE03lw=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 7/8] Staging: remove dupilcated #include
Date: Mon,  6 Apr 2009 17:20:23 +0800
Message-Id: <1239009623-3640-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dupilcated #include in drivers/staging/rt3070/rt_linux.h.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/staging/rt3070/rt_linux.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt3070/rt_linux.h b/drivers/staging/rt3070/rt_linux.h
index 0540d02..b5566ee 100644
--- a/drivers/staging/rt3070/rt_linux.h
+++ b/drivers/staging/rt3070/rt_linux.h
@@ -65,7 +65,6 @@
 #include <linux/vmalloc.h>
 
 
-#include <linux/wireless.h>
 #include <net/iw_handler.h>
 
 // load firmware
-- 
1.6.1.3

