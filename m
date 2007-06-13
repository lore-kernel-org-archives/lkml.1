Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbXFMGIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbXFMGIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXFMGIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:08:37 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:59326 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbXFMGIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:08:36 -0400
Date: Wed, 13 Jun 2007 16:08:35 +1000
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Include hrtimer.h in tick.h.
Message-ID: <20070613060835.GN15955@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Breeds <tony@bakeyournoodle.com>

struct tick_shed in tick.h uses struct hrtimer, explictly include the
hrtimer header file to make sure this is defined.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---

 include/linux/tick.h |    1 +
 1 file changed, 1 insertion(+)

Index: working/include/linux/tick.h
===================================================================
--- working.orig/include/linux/tick.h
+++ working/include/linux/tick.h
@@ -7,6 +7,7 @@
 #define _LINUX_TICK_H
 
 #include <linux/clockchips.h>
+#include <linux/hrtimer.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

