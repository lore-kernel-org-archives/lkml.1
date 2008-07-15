Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbYGOAMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbYGOAMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760267AbYGOAMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:12:07 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:58228 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760263AbYGOAMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:12:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkEAG+Ee0hMRKxB/2dsb2JhbACBWapv
Date: Mon, 14 Jul 2008 20:12:02 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@shafik.org, linux-kernel@vger.kernel.org
Subject: LTTng 0.10 for kernel 2.6.26
Message-ID: <20080715001202.GA21184@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:00:34 up 40 days,  4:41,  5 users,  load average: 1.11, 0.63,
	0.46
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released LTTng kernel tracer 0.10 for kernel 2.6.26. The new
userspace markers now have a brand new package, which includes the
linker script for x86 32 and 64 bits and example code and Makefile,
available at :
http://ltt.polymtl.ca/packages/markers-userspace-0.5.tar.bz2

As always, the kernel patches are available at :
http://ltt.polymtl.ca/lttng/patch-2.6.26-0.10.tar.bz2

The userspace tracing control tool :
http://ltt.polymtl.ca/lttng/ltt-control-0.49-14072008.tar.gz

The trace viewer :
http://ltt.polymtl.ca/packages/lttv-0.10.0-pre13-27052008.tar.gz

There is currently limited userspace tracing support :

- It traces through a system call
- It records a string taken from the syscall parameter to the kernel
  event "userspace_string". It's not as compact as the kernel binary
  format, but it "does the job" for now. Other type support are WIP.
- The markers userspace object, linked with the binary, adds a section
  to describe the markers and new constructors/destructors to register
  the markers to the kernel.
- It supports instrumentation of libraries and executables.
- It is currently limited to activation of system-wide tracepoints. The
  easiest way to activate them is to have them registered when
  ltt-armalluser is executed. It will automatically find them through
  /proc and enable them system-wide. They will then be automatically
  activated for all new processes created which register these markers.
- It is better to tell yourself to /proc/ltt to activate the named
  markers if you plan to run a program which has a short execution time,
  because they would have to be enabled before they are listed in /proc.
  See the ltt-armalluser script as an example; just put your own marker
  name instead.

Feedback is welcome.

See the version compatibility list for details :
http://ltt.polymtl.ca/svn/ltt/branches/poly/doc/developer/lttng-lttv-compatibility.html
And follow the quickstart guide for instructions about how to install
and use the tools.
http://ltt.polymtl.ca/svn/ltt/branches/poly/QUICKSTART


Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
