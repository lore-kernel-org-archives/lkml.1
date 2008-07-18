Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbYGRVvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbYGRVvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYGRVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:51:15 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:36251 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbYGRVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:51:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEACmqgEhMRKxB/2dsb2JhbACBWq8e
Date: Fri, 18 Jul 2008 17:51:12 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull tip/tracing/immediates] Immediate values fixes/redux
Message-ID: <20080718215112.GA7058@Krystal>
References: <20080717031721.GA24504@Krystal> <20080718161523.GY6875@elte.hu> <20080718183124.GA31768@Krystal> <4880F410.3090804@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4880F410.3090804@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:45:54 up 44 days,  2:26,  5 users,  load average: 4.29, 1.57,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are fixes for the tip/tracing/immediates tree, with the last patch
being the removal of the static branch code.

It is available at :

git://ltt.polymtl.ca/linux-2.6-instrumentation.git tracing/immediates-pull

I first added the missing dependencies (text edit lock and kprobes mutex
modifications) :

kprobes-use-mutex-for-insn-pages.patch
kprobes-dont-use-kprobes-mutex-in-arch-code.patch
kprobes-declare-kprobes-mutex-static.patch
text-edit-lock-architecture-independent-code.patch
text-edit-lock-kprobes-architecture-independent-support.patch

Then comes the fixes and added debugging code :

immediate-values-remove-on_each_cpu-argument.patch
immediate-values-use-i-asm-constraint.patch
fix-immediate-values-x86_64-support-old-gcc.patch
immediate-values-remove-var-size-field-from-jump-optimization.patch
immediate-values-optimized-jump-add-debug.patch

And finally removal of static jump :

markers-use-conditional-branch-instead-of-static-jump.patch
immediate-values-remove-static-jump.patch

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
