Return-Path: <linux-kernel-owner+w=401wt.eu-S1161542AbXECS2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161542AbXECS2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162228AbXECS2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:28:33 -0400
Received: from mail.aknet.ru ([82.179.72.26]:56948 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161542AbXECS2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:28:32 -0400
X-Greylist: delayed 1998 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 14:28:32 EDT
Message-ID: <463A2296.7000804@aknet.ru>
Date: Thu, 03 May 2007 21:57:42 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>
Subject: [patch] export hrtimer_forward
Content-Type: multipart/mixed;
 boundary="------------080609060005050107000903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080609060005050107000903
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

It seems hrtimer_forward was forgotten to
export - other symbols of the hrtimers API
are already exported.
Unless I am missing something, using the
hrtimers without that function is problematic.

Andrew, could you please apply?

Signed-off-by: <stsp@aknet.ru>


--------------080609060005050107000903
Content-Type: text/x-patch;
 name="exp_hrfwd.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="exp_hrfwd.diff"

--- a/kernel/hrtimer.c	2007-04-27 13:00:25.000000000 +0400
+++ b/kernel/hrtimer.c	2007-05-03 17:27:40.000000000 +0400
@@ -666,6 +666,7 @@
 
 	return orun;
 }
+EXPORT_SYMBOL_GPL(hrtimer_forward);
 
 /*
  * enqueue_hrtimer - internal function to (re)start a timer

--------------080609060005050107000903--
