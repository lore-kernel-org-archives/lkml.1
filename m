Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbYCMQCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbYCMQCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYCMQCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:02:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27424 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYCMQCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:02:08 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH 08/10] avr32: Define TIF_FREEZE
Date: Thu, 13 Mar 2008 15:39:43 +0100
Message-Id: <1205419185-26395-9-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205419185-26395-8-git-send-email-hskinnemoen@atmel.com>
References: <>
 <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-4-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-5-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-6-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-7-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-8-git-send-email-hskinnemoen@atmel.com>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0539 (UTC) FILETIME=[156F63B0:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 include/asm-avr32/thread_info.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-avr32/thread_info.h b/include/asm-avr32/thread_info.h
index 07049f6..df68631 100644
--- a/include/asm-avr32/thread_info.h
+++ b/include/asm-avr32/thread_info.h
@@ -88,6 +88,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
+#define TIF_FREEZE		29
 #define TIF_DEBUG		30	/* debugging enabled */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
-- 
1.5.4.3

