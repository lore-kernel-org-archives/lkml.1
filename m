Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYJQR4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYJQR4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYJQR4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:56:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60745 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbYJQR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:56:15 -0400
Date: Fri, 17 Oct 2008 20:56:00 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: david@rowetel.com, steveu@coppice.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] echo: remove __cplusplus macro magic
Message-ID: <Pine.LNX.4.64.0810172055330.23852@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The kernel is written in C, so remove the __cplusplus macro magic from the
driver.

Cc: David Rowe <david@rowetel.com>
Cc: Steve Underwood <steveu@coppice.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
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
index 42d900d..b471003 100644
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
1.5.3.7

