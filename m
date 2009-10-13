Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbZJMA2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbZJMA2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZJMA2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:28:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:37717 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbZJMA2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:28:51 -0400
Message-ID: <4AD3C99B.8040507@suse.com>
Date: Mon, 12 Oct 2009 20:28:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-1.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: more sched.h fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains more sched.h additions for drivers that built
fine under x86_64 but not i386 for some reason.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/staging/rt2860/common/cmm_info.c |    1 +
 drivers/staging/rt2860/rt_linux.c        |    1 +
 drivers/staging/rt3090/common/cmm_info.c |    1 +
 drivers/staging/rt3090/rt_linux.c        |    1 +
 4 files changed, 4 insertions(+)

--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -25,6 +25,7 @@
  *************************************************************************
 */
 
+#include <linux/sched.h>
 #include "../rt_config.h"
 
 INT	Show_SSID_Proc(
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -25,6 +25,7 @@
  *************************************************************************
  */
 
+#include <linux/sched.h>
 #include "rt_config.h"
 
 ULONG	RTDebugLevel = RT_DEBUG_ERROR;
--- a/drivers/staging/rt3090/common/cmm_info.c
+++ b/drivers/staging/rt3090/common/cmm_info.c
@@ -34,6 +34,7 @@
     ---------    ----------    ----------------------------------------------
  */
 
+#include <linux/sched.h>
 #include "../rt_config.h"
 
 
--- a/drivers/staging/rt3090/rt_linux.c
+++ b/drivers/staging/rt3090/rt_linux.c
@@ -25,6 +25,7 @@
  *************************************************************************
  */
 
+#include <linux/sched.h>
 #include "rt_config.h"
 
 ULONG	RTDebugLevel = RT_DEBUG_ERROR;
-- 
Jeff Mahoney
SUSE Labs
