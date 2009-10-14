Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZJNRmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZJNRmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZJNRmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:42:15 -0400
Received: from kroah.org ([198.145.64.141]:42741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbZJNRmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:42:15 -0400
Subject: patch staging-more-sched.h-fixes.patch added to gregkh-2.6 tree
To: jeffm@suse.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 14 Oct 2009 10:38:56 -0700
In-Reply-To: <4AD3C99B.8040507@suse.com>
Message-ID: <1255541936728@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: more sched.h fixes

to my gregkh-2.6 tree.  Its filename is

    staging-more-sched.h-fixes.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From jeffm@suse.com  Wed Oct 14 10:18:54 2009
From: Jeff Mahoney <jeffm@suse.com>
Date: Mon, 12 Oct 2009 20:28:11 -0400
Subject: staging: more sched.h fixes
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <4AD3C99B.8040507@suse.com>


This patch contains more sched.h additions for drivers that built
fine under x86_64 but not i386 for some reason.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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

