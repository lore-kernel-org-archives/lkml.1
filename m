Return-Path: <linux-kernel-owner+w=401wt.eu-S1161220AbXBOU7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161220AbXBOU7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161251AbXBOU7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:59:11 -0500
Received: from mail.nagafix.co.uk ([194.145.196.85]:46168 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161220AbXBOU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:59:10 -0500
Message-ID: <45D4C999.4080507@nagafix.co.uk>
Date: Thu, 15 Feb 2007 20:59:05 +0000
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug() - 2.6.18.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just caught this in the log whilst running some unit tests.
(the test was in the process of starting 900 Java threads)

audit(1171565587.887:96): enforcing=0 old_enforcing=1 auid=4294967295
BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug()

Call Trace:
  [<ffffffff80269c98>] dump_stack+0x12/0x17
  [<ffffffff8029dfe6>] unlock_cpu_hotplug+0x3f/0x6c
  [<ffffffff802876b6>] sched_getaffinity+0x7d/0xa2
  [<ffffffff80287701>] sys_sched_getaffinity+0x26/0x55
  [<ffffffff8025cb0e>] system_call+0x7e/0x83
DWARF2 unwinder stuck at system_call+0x7e/0x83
Leftover inexact backtrace:

audit(1171579693.653:97): avc:  denied  { connectto } for  pid=9211 
comm="mount" name=".setrans-unix" scontext=system_u:system_r:mount_t:s0 
tcontext=system_u:system_r:initrc_t:s0 tclass=unix_stream_socket
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sdb3, type ext3), uses xattr
