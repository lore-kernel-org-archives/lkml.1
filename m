Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZKURyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZKURyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZKURyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:54:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:35498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558AbZKURyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:54:19 -0500
Subject: [PATCH] ioq: includecheck fix
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Gregory Haskins <ghaskins@novell.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Nov 2009 23:22:55 +0530
Message-Id: <1258825975.5364.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  include/linux/ioq.h: linux/shm_signal.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>
---
 include/linux/ioq.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/ioq.h b/include/linux/ioq.h
index f77e316..eba1021 100644
--- a/include/linux/ioq.h
+++ b/include/linux/ioq.h
@@ -91,7 +91,6 @@ struct ioq_ring_head {
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/interrupt.h>
-#include <linux/shm_signal.h>
 #include <linux/kref.h>
 
 enum ioq_idx_type {
-- 
1.6.0.6


