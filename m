Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYDXVbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYDXVbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYDXVb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:31:27 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:46656 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYDXVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:31:26 -0400
Date: Thu, 24 Apr 2008 17:31:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, mingo@redhat.com
Subject: [PATCH] Drop "init_mm" from being exported via
 EXPORT_UNUSED_SYMBOL.
Message-ID: <alpine.LFD.1.10.0804241728510.4087@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  since this was listed as removable as of 2.6.26, does that mean its
removal can go into an appropriate tree now?  or would that mean
*after* the release of 2.6.26?

diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index 3d01e47..5b3ce79 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -15,7 +15,6 @@ static struct files_struct init_files = INIT_FILES;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */

 /*
  * Initial thread structure.
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
