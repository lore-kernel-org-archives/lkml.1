Return-Path: <linux-kernel-owner+w=401wt.eu-S1750810AbXCDEHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750810AbXCDEHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 23:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbXCDEHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 23:07:23 -0500
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:1465 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbXCDEHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 23:07:22 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20, Java, unresponsive userspace
Date: Sun, 4 Mar 2007 04:07:07 +0000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703040407.07234.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've had some problems with 2.6.20 (but also with earlier kernels, like 
Debian's 2.6.18) where one of the users on our system, running a Java6 
application, is somehow able to make the userspace on the machine totally 
unresponsive, denying all remote _and_ local access to the machine.

- The AMD64 port of Linux and Java are in use
- The process runs as an unprivileged user
- The OOM killer doesn't kick in
- No swap is enabled on the machine
- I'm told that the program doesn't fork bomb
  (but I've not got a reproducible test case yet)
- The program is able to deny service even to a getty login.

If I SAK the machine, init respawns getty and everything is fine again.

alistair@clarent:~$ ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
max nice                        (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) unlimited
max locked memory       (kbytes, -l) 1000
max memory size         (kbytes, -m) 1000
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) unlimited
max rt priority                 (-r) 0
stack size              (kbytes, -s) 2048
cpu time               (seconds, -t) unlimited
max user processes              (-u) 100
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited

Any ideas with how to proceed for debugging this issue?

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
