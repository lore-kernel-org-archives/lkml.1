Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbXJLHxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbXJLHxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXJLHxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:53:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51681 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbXJLHxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:53:15 -0400
X-Greylist: delayed 3114 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 03:53:14 EDT
Message-Id: <200710120701.l9C71Jx6038998@www262.sakura.ne.jp>
Subject: How to find slab\'s usage?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Oct 2007 16:01:19 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I was compiling Ubuntu 7.10's kernel and I encountered OOM-killer.

I saw /proc/meminfo and it seems to me that slab is leaking memory.
But /usr/bin/slabtop claims /proc/slabinfo is missing.

I couldn't continue the compilation before reboot.
I could continue the compilation after reboot.
So, I think this is a memory leak.
How can I find slab that uses so much memory?

Regards.



# cat /proc/version
Linux version 2.6.22-14-server (buildd@vernadsky) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Wed Oct 10 06:35:59 GMT 2007

# cat /proc/meminfo
MemTotal:       515756 kB
MemFree:         24628 kB
Buffers:          1372 kB
Cached:          15324 kB
SwapCached:          0 kB
Active:          15140 kB
Inactive:         5936 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:       515756 kB
LowFree:         24628 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:              12 kB
Writeback:           8 kB
AnonPages:        4396 kB
Mapped:           1076 kB
Slab:           311236 kB
SReclaimable:    11268 kB
SUnreclaim:     299968 kB
PageTables:        264 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    257876 kB
Committed_AS:     7780 kB
VmallocTotal:   511992 kB
VmallocUsed:      2204 kB
VmallocChunk:   509364 kB
