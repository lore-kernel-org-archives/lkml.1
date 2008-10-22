Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYJVRjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYJVRjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbYJVRdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:43 -0400
Received: from kroah.org ([198.145.64.141]:53055 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757460AbYJVRdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tzafrir Cohen <tzafrir@cohens.org.il>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/42] Staging: echo: Export interface functions. Add module headers.
Date: Wed, 22 Oct 2008 10:28:59 -0700
Message-Id: <1224696563-5170-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tzafrir Cohen <tzafrir@cohens.org.il>

Signed-off-by: Tzafrir Cohen <tzafrir@cohens.org.il>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/echo/echo.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index 4a281b1..0a03eed 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -289,6 +289,7 @@ echo_can_state_t *echo_can_create(int len, int adaption_mode)
 
     return  ec;
 }
+EXPORT_SYMBOL_GPL(echo_can_create);
 /*- End of function --------------------------------------------------------*/
 
 void echo_can_free(echo_can_state_t *ec)
@@ -302,12 +303,14 @@ void echo_can_free(echo_can_state_t *ec)
 	kfree(ec->snapshot);
 	kfree(ec);
 }
+EXPORT_SYMBOL_GPL(echo_can_free);
 /*- End of function --------------------------------------------------------*/
 
 void echo_can_adaption_mode(echo_can_state_t *ec, int adaption_mode)
 {
     ec->adaption_mode = adaption_mode;
 }
+EXPORT_SYMBOL_GPL(echo_can_adaption_mode);
 /*- End of function --------------------------------------------------------*/
 
 void echo_can_flush(echo_can_state_t *ec)
@@ -334,11 +337,13 @@ void echo_can_flush(echo_can_state_t *ec)
     ec->curr_pos = ec->taps - 1;
     ec->Pstates = 0;
 }
+EXPORT_SYMBOL_GPL(echo_can_flush);
 /*- End of function --------------------------------------------------------*/
 
 void echo_can_snapshot(echo_can_state_t *ec) {
     memcpy(ec->snapshot, ec->fir_taps16[0], ec->taps*sizeof(int16_t));
 }
+EXPORT_SYMBOL_GPL(echo_can_snapshot);
 /*- End of function --------------------------------------------------------*/
 
 /* Dual Path Echo Canceller ------------------------------------------------*/
@@ -584,7 +589,7 @@ int16_t echo_can_update(echo_can_state_t *ec, int16_t tx, int16_t rx)
 
     return (int16_t) ec->clean_nlp << 1;
 }
-
+EXPORT_SYMBOL_GPL(echo_can_update);
 /*- End of function --------------------------------------------------------*/
 
 /* This function is seperated from the echo canceller is it is usually called
@@ -630,3 +635,9 @@ int16_t echo_can_hpf_tx(echo_can_state_t *ec, int16_t tx) {
 
     return tx;
 }
+EXPORT_SYMBOL_GPL(echo_can_hpf_tx);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Rowe");
+MODULE_DESCRIPTION("Open Source Line Echo Canceller");
+MODULE_VERSION("0.3.0");
-- 
1.6.0.2

