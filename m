Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZJBKQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZJBKQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbZJBKQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:16:10 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48299 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbZJBKQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=bnaTqa4lvaQyc8dk/22vD7grQxHBEH7qXB7DGnXJFCr3D+tkyoYqZRyjWisWkq4HNR
         Pbrw7qjy7X/yWgWQXjZw5HXm82Rh08e1Q74xuAZPx3T3QjUj9lfMRJkJjqKev9IuSQKo
         U6fbLE+K0dnP2Yz9Qyk1AaGhZHJEumhu5QDbw=
MIME-Version: 1.0
Date: Fri, 2 Oct 2009 12:16:12 +0200
Message-ID: <40a4ed590910020316t50800e0m6958a335cfdcaf3b@mail.gmail.com>
Subject: When this happens my Machine hangs - Kernel 2.6.32-rc2: INFO: task 
	master:26085 blocked for more than 120 seconds
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am on: Linux zenogentoo 2.6.32-rc2 #63 SMP PREEMPT Mon Sep 28
16:04:45 CEST 2009 i686 Intel(R) Pentium(R) 4 CPU 3.00GHz GenuineIntel
GNU/Linux

from /var/log/messages right at the time of the hang:

Oct  2 12:00:01 zenogentoo cron[26059]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons )
Oct  2 12:07:40 zenogentoo INFO: task master:26085 blocked for more
than 120 seconds.
Oct  2 12:07:40 zenogentoo "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  2 12:07:40 zenogentoo master        D 0000e15b     0 26085   3117
0x00000000
Oct  2 12:07:40 zenogentoo f72b7e90 00000086 669d4ad6 0000e15b
c1693980 00000001 c2a08980 f72b7e64
Oct  2 12:07:40 zenogentoo c107bfdf f72b7e54 c168f084 f72280b0
f7228248 c2a08500 00000001 00000001
Oct  2 12:07:40 zenogentoo c1693500 c2804104 f7228248 f722817c
c2804104 f72b7e88 0002a25f 00000000
Oct  2 12:07:40 zenogentoo Call Trace:
Oct  2 12:07:40 zenogentoo [<c107bfdf>] ? sched_clock_cpu+0xc4/0xf8
Oct  2 12:07:40 zenogentoo [<c1473842>] schedule_timeout+0x242/0x2ad
Oct  2 12:07:40 zenogentoo [<c1031368>] ? sched_clock+0x8/0xb
Oct  2 12:07:40 zenogentoo [<c107be97>] ? sched_clock_local+0x91/0x115
Oct  2 12:07:40 zenogentoo [<c107bfdf>] ? sched_clock_cpu+0xc4/0xf8
Oct  2 12:07:40 zenogentoo [<c1474c83>] ? _spin_lock+0x10/0x27
Oct  2 12:07:40 zenogentoo [<c1472af1>] wait_for_common+0xa9/0x10a
Oct  2 12:07:40 zenogentoo [<c1056373>] ? default_wake_function+0x0/0xd
Oct  2 12:07:40 zenogentoo [<c1472bc4>] wait_for_completion+0x12/0x14
Oct  2 12:07:40 zenogentoo [<c105c836>] sched_exec+0xd5/0xe4
Oct  2 12:07:40 zenogentoo [<c10df99d>] do_execve+0x138/0x378
Oct  2 12:07:40 zenogentoo [<c1029fcf>] sys_execve+0x35/0x61
Oct  2 12:07:40 zenogentoo [<c102b690>] sysenter_do_call+0x12/0x2c
Oct  2 12:08:08 zenogentoo sudo: pam_unix(sudo:auth): authentication
failure; logname=zeno uid=0 euid=0 tty=pts/0 ruser= rhost=  user=zeno
Oct  2 12:08:12 zenogentoo sudo:     zeno : TTY=pts/0 ; PWD=/home/zeno
; USER=root ; COMMAND=/usr/bin/vi /var/log/messages
Oct  2 12:09:40 zenogentoo INFO: task master:26085 blocked for more
than 120 seconds.
Oct  2 12:09:40 zenogentoo "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  2 12:09:40 zenogentoo master        D 0000e15b     0 26085   3117
0x00000000
Oct  2 12:09:40 zenogentoo f72b7e90 00000086 669d4ad6 0000e15b
c1693980 00000001 c2a08980 f72b7e64
Oct  2 12:09:40 zenogentoo c107bfdf f72b7e54 c168f084 f72280b0
f7228248 c2a08500 00000001 00000001
Oct  2 12:09:40 zenogentoo c1693500 c2804104 f7228248 f722817c
c2804104 f72b7e88 0002a25f 00000000
Oct  2 12:09:40 zenogentoo Call Trace:
Oct  2 12:09:40 zenogentoo [<c107bfdf>] ? sched_clock_cpu+0xc4/0xf8
Oct  2 12:09:40 zenogentoo [<c1473842>] schedule_timeout+0x242/0x2ad
Oct  2 12:09:40 zenogentoo [<c1031368>] ? sched_clock+0x8/0xb
Oct  2 12:09:40 zenogentoo [<c107be97>] ? sched_clock_local+0x91/0x115
Oct  2 12:09:40 zenogentoo [<c107bfdf>] ? sched_clock_cpu+0xc4/0xf8
Oct  2 12:09:40 zenogentoo [<c1474c83>] ? _spin_lock+0x10/0x27
Oct  2 12:09:40 zenogentoo [<c1472af1>] wait_for_common+0xa9/0x10a
Oct  2 12:09:40 zenogentoo [<c1056373>] ? default_wake_function+0x0/0xd
Oct  2 12:09:40 zenogentoo [<c1472bc4>] wait_for_completion+0x12/0x14
Oct  2 12:09:40 zenogentoo [<c105c836>] sched_exec+0xd5/0xe4
Oct  2 12:09:40 zenogentoo [<c10df99d>] do_execve+0x138/0x378
Oct  2 12:09:40 zenogentoo [<c1029fcf>] sys_execve+0x35/0x61
Oct  2 12:09:40 zenogentoo [<c102b690>] sysenter_do_call+0x12/0x2c

Any hints are welcome.

Best
Zeno
