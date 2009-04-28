Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbZD1NUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbZD1NUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZD1NUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:20:42 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:33621 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbZD1NUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:20:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEADea9klMQW1W/2dsb2JhbACBUM1Lg3MF
Date: Tue, 28 Apr 2009 09:20:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: LTTng "TIF_KERNEL_TRACE"
Message-ID: <20090428132037.GA27519@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:14:21 up 59 days,  9:40,  2 users,  load average: 0.28, 0.54,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Looking at the current -tip tree, I notice that the TIF_SYSCALL_FTRACE
flag is only implemented for x86.

I have TIF_KERNEL_TRACE in my lttng tree which applies to all
architectures to do the exact same thing :

lttng-kernel-trace-thread-flag-alpha.patch
lttng-kernel-trace-thread-flag-arm.patch
lttng-kernel-trace-thread-flag-avr32.patch
lttng-kernel-trace-thread-flag-blackfin.patch
lttng-kernel-trace-thread-flag-cris.patch
lttng-kernel-trace-thread-flag-frv.patch
lttng-kernel-trace-thread-flag-h8300.patch
lttng-kernel-trace-thread-flag-ia64.patch
lttng-kernel-trace-thread-flag-m32r.patch
lttng-kernel-trace-thread-flag-m68k.patch
lttng-kernel-trace-thread-flag-mips.patch
lttng-kernel-trace-thread-flag-parisc.patch
lttng-kernel-trace-thread-flag-powerpc.patch
lttng-kernel-trace-thread-flag-s390.patch
lttng-kernel-trace-thread-flag-sh.patch
lttng-kernel-trace-thread-flag-sparc.patch
lttng-kernel-trace-thread-flag-um.patch
lttng-kernel-trace-thread-flag-x86.patch
lttng-kernel-trace-thread-flag-xtensa.patch
lttng-kernel-trace-thread-flag-api.patch

Is there any way we could get this merged ?

One thing I like about the name TIF_KERNEL_TRACE compared to
TIF_SYSCALL_FTRACE is that it gives us a per-thread flag that could
eventually be used for more kernel tracing purposes than just syscalls.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
