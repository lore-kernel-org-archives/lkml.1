Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYJVRmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYJVRmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbYJVReZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:34:25 -0400
Received: from kroah.org ([198.145.64.141]:53078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757592AbYJVReX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:34:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Rowe <david@rowetel.com>,
       Steve Underwood <steveu@coppice.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/42] Staging: echo: remove __cplusplus macro magic
Date: Wed, 22 Oct 2008 10:29:05 -0700
Message-Id: <1224696563-5170-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The kernel is written in C, so remove the __cplusplus macro magic from the
driver.

Cc: David Rowe <david@rowetel.com>
Cc: Steve Underwood <steveu@coppice.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/echo/bit_operations.h |    8 --------
 drivers/staging/echo/fir.h            |    8 --------
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/echo/bit_operations.h b/drivers/staging/echo/bit_operations.h
index b32f4bf..04b55d2 100644
--- a/drivers/staging/echo/bit_operations.h
+++ b/drivers/staging/echo/bit_operations.h
@@ -30,10 +30,6 @@
 #if !defined(_BIT_OPERATIONS_H_)
 #define _BIT_OPERATIONS_H_
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 #if defined(__i386__)  ||  defined(__x86_64__)
 /*! \brief Find the bit position of the highest set bit in a word
     \param bits The word to be searched
@@ -245,9 +241,5 @@ static __inline__ int parity32(uint32_t x)
 }
 /*- End of function --------------------------------------------------------*/
 
-#ifdef __cplusplus
-}
-#endif
-
 #endif
 /*- End of file ------------------------------------------------------------*/
diff --git a/drivers/staging/echo/fir.h b/drivers/staging/echo/fir.h
index 19c20cd..d1df33c 100644
--- a/drivers/staging/echo/fir.h
+++ b/drivers/staging/echo/fir.h
@@ -105,10 +105,6 @@ typedef struct
 	float *history;
 } fir_float_state_t;
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 static __inline__ const int16_t *fir16_create(fir16_state_t *fir,
                                               const int16_t *coeffs,
                                               int taps)
@@ -312,9 +308,5 @@ static __inline__ int16_t fir32(fir32_state_t *fir, int16_t sample)
 }
 /*- End of function --------------------------------------------------------*/
 
-#ifdef __cplusplus
-}
-#endif
-
 #endif
 /*- End of file ------------------------------------------------------------*/
-- 
1.6.0.2

