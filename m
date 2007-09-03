Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbXICKWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbXICKWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbXICKWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:22:15 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:44458 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbXICKWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:22:13 -0400
Message-ID: <46DBE031.1090808@free.fr>
Date: Mon, 03 Sep 2007 12:21:37 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       linux-rt-users <linux-rt-users@vger.kernel.org>
CC: johnstul@us.ibm.com, tglx@linutronix.de
Subject: System clock frequency offset changes drastically across reboots
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Re-sending... Please feel free to comment, even if you don't have
"The Solution". I'd just like to get some feedback. ]

Hello everyone,

I'm using 2.6.20.7-rt8 on a P3.

I've noticed that the frequency offset of my system clock (computed
either by ntpd, or by hand) changes drastically across reboots.

By drastically, I mean +/- 60 ppm every time I reboot.

Apparently this is caused by some imprecision in the frequency
estimation done in calculate_cpu_khz() (arch/i386/kernel/tsc.c)

My brutally crude work-around was to skip the computation altogether and
hard-code the "correct" value for cpu_khz.

http://linux.kernel.free.fr/cpu_khz.adlink

Has this issue been investigated more thoroughly by other users?

Regards.

