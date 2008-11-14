Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYKNTz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYKNTz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYKNTzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:55:46 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62784 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755166AbYKNTzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:55:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAJNjHUlMQWxa/2dsb2JhbACBbc8Sgnk
Date: Fri, 14 Nov 2008 14:55:39 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: LTTng 0.55 for 2.6.27.6, tracepoint updates
Message-ID: <20081114195539.GA2393@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:49:28 up 163 days, 29 min,  5 users,  load average: 0.64,
	0.75, 0.98
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTTng 0.55 now requires tracepoints to be declared (in
include/trace/*.h), defined (in a C file), and optionally exported. The
documentation in Documentation/tracepoint.txt is updated accordingly, as
well as the LTTng instrumentation.

This removes the static declaration per-tracepoint which will make them
suitable for kmemtrace.

The main patch implementing this API change is :

http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commitdiff;h=e15badc57e49250c6a8209b31014706dbb9f0212;hp=8233bb29925bd807619d800d28aaf694221f72ab

I will post updates to tracepoints and markers ported to 2.6.28-rc soon.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
