Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbXCYQGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbXCYQGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXCYQGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:06:30 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:48961 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbXCYQG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:reply-to:to:cc:subject:message-id:mime-version:content-type:from;
        b=A1WDBpxsz8wEsfsqiMXYb/fxZ7dHPa5Y2VR2okxpXRPRS5+h/uXyJT8BOJRHQLC9ldRL6aHt7GEYUynD/meDSnfhEr1kmnHWzTud+dZNmIpRugFcbjtbh5cEoeg4Ww/smUpFYSsVWbecHSors1sEIy/C91p8nlELJBaj2/PLfTY=
Date: Sun, 25 Mar 2007 12:06:19 -0400 (EDT)
Reply-To: parag.warudkar@gmail.com
To: linux-kernel@vger.kernel.org
cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: apm.c: get rid of unused variables
Message-ID: <Pine.LNX.4.64.0703251158400.17623@paragw-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The patch below (against latest git) gets rid of following unused 
variables - clock_cmos_diff and got_clock_diff.

2 less compiler warnings.

Compile tested on i386.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/arch/i386/kernel/apm.c	2007-03-24 21:43:35.000000000 -0400
+++ linux-2.6-wk/arch/i386/kernel/apm.c	2007-03-25 11:50:16.000000000 -0400
@@ -384,13 +384,6 @@
  static int			ignore_normal_resume;
  static int			bounce_interval __read_mostly = DEFAULT_BOUNCE_INTERVAL;

-#ifdef CONFIG_APM_RTC_IS_GMT
-#	define	clock_cmos_diff	0
-#	define	got_clock_diff	1
-#else
-static long			clock_cmos_diff;
-static int			got_clock_diff;
-#endif
  static int			debug __read_mostly;
  static int			smp __read_mostly;
  static int			apm_disabled = -1;
