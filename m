Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbYAYXDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbYAYXDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbYAYXCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:02:50 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22144 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760883AbYAYXCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:02:48 -0500
Message-ID: <479A6A96.7060805@msgid.tls.msk.ru>
Date: Sat, 26 Jan 2008 02:02:46 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: tickless/dynticks + cpufreq = tsc unstable
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it normal that once I enable cpufreq on
a tickless system, it spews a warning:

Clocksource tsc unstable (delta = -288201154 ns)

?

It's an old problem, and I was thinking about
differences between x86-64 (it worked there) and
i386 kernels.  But with 2.6.24, x86-64 can run
tickless as well, and once I enable this mode,
and load dynamic cpufreq governor, the above message
gets printed too.

The system is amd x2-64, all kernels since tickless
has been introduced.

I'm not sure if it's really something to worry about --
probably not, as this system has hpet.  But on another
system, Intel-based, where there was no hpet and jiffies
clocksourse gets selected instead, there were some...
issues still (I don't remember offhand which ones, will
check the next week with new kernel).

Thanks!

/mjt
