Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbZKNQOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbZKNQOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 11:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZKNQOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 11:14:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:53170 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751548AbZKNQOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 11:14:22 -0500
X-Authenticated: #3373616
X-Provags-ID: V01U2FsdGVkX1843t8+KWg4/oXPkAUV/XdtlQqj/7C5guZGLEZQRt
	k+Op7O5DYVIk6f
Message-ID: <4AFEE55B.3000906@gmx.de>
Date: Sun, 15 Nov 2009 03:14:03 +1000
From: =?ISO-8859-15?Q?Simon_K=E4mpflein?= <s.kaempflein@gmx.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: perf counters: problem with perf record
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a problem with the new kernel perf tools in kernel 2.6.31.6 (very
nice tools by the way). I like to monitor the cache-misses of a program.
"perf stat -e cache-misses program" works without problems, but I can't
get "perf record -e cache-misses program" working (even running as root
and CONFIG_PERF_COUNTERS=y):

Error: perfcounter syscall returned with -1 (Operation not supported)
Fatal: No CONFIG_PERF_COUNTERS=y kernel support configured?

strace of "perf stat":
SYS_336(0x8508da0, 0x1074, 0xffffffff, 0xffffffff, 0) = 3

strace of "perf record":
SYS_336(0x8508da0, 0xf85, 0xffffffff, 0xffffffff, 0) = -1 EOPNOTSUPP
(Operation not supported)

My CPU is a "Intel(R) Pentium(R) M processor 1.80GHz":
[    0.004337] p6 PMU driver.
[    0.004343] ... version:                 0
[    0.004345] ... bit width:               32
[    0.004347] ... generic counters:        2
[    0.004349] ... value mask:              00000000ffffffff
[    0.004351] ... max period:              000000007fffffff
[    0.004353] ... fixed-purpose counters:  0
[    0.004355] ... counter mask:            0000000000000003

Best regards,
Simon


