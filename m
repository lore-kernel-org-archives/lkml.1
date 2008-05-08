Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbYEHNIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbYEHNIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYEHNId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:08:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:31012 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbYEHNIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type:content-transfer-encoding:x-mailer;
        b=es6MmGdNeZZdIwnc0rgcWdPOWRPuOAJMDuWoA2rwQdi/nKHFUyRljhnC5qixqesouh5IqzmIsfwRG9Rxz96ipQGNvVKV40btAaUXXfYjM5kbQ19HnSLJntCg7jW0UcR6MU7uvrAWgs+0raG70aUmlVgHaEd5cXRrpFhHMClidck=
Date: Thu, 08 May 2008 21:08:30 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: dipankar@in.ibm.com
Subject: [RCU] remove duplicated include in kernel/rcupreempt_trace.c
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080508210700.8958.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated include file <linux/rcupdate.h> in kernel/rcupreempt_trace.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

--- a/kernel/rcupreempt_trace.c 2008-05-08 20:46:54.000000000 +0800
+++ b/kernel/rcupreempt_trace.c 2008-05-08 20:47:12.000000000 +0800
@@ -38,7 +38,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/rcupreempt_trace.h>


