Return-Path: <linux-kernel-owner+w=401wt.eu-S1423592AbXEDKRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423592AbXEDKRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422950AbXEDKRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:17:11 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41099 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993188AbXEDKRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:17:10 -0400
Date: Fri, 4 May 2007 12:16:21 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: davej@codemonkey.org.uk
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk
Subject: cpufreq longhaul locks up
Message-ID: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I found that setting the cpufreq governor to ondemand making the box 
lock up solid in 2.6.20.2 and 2.6.21 after a few seconds. Sysrq 
does not work anymore, and the last messages are:

May  3 19:16:58 cn kernel: longhaul: VIA C3 'Nehemiah C' [C5P] CPU 
detected.  Powersaver supported.
May  3 19:16:58 cn kernel: longhaul: Using northbridge support.
May  3 19:17:22 cn kernel: Time: acpi_pm clocksource has been installed.
May  3 19:17:22 cn kernel: Clocksource tsc unstable (delta = -136422685 
ns)

I have also tried 2.6.20.2 in single-user mode (so that I can have 
the disk readonly), and it take a little longer (magnitude: minutes) 
to lock up; not sure if it's 20.2 or the single-user mode but I suspect 
the latter since nothing is running then that could potentially 
contribute to quickly changing workloads/frequencies.

If you need more info, please let me know.


Thanks,
Jan
-- 
