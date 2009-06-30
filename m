Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZF3UU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZF3UU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZF3UUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:20:18 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:18506 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZF3UUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:20:18 -0400
Message-ID: <4A4A7364.1090108@oracle.com>
Date: Tue, 30 Jun 2009 13:19:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-06-30-12-50 uploaded
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <54770.1246392952@turing-police.cc.vt.edu>
In-Reply-To: <54770.1246392952@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A4A7366.009E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
>> The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to
> 
> This dies with quilt 0.44, thusly:
> 
> Applying patch procfs-provide-stack-information-for-threads-v08.patch
> can't find file to patch at input line 20
> Perhaps you used the wrong -p or --strip option?
> The text leading up to this was:
> --------------------------
> |From: Stefani Seibold <stefani@seibold.net>
> |
> |A patch to give a better overview of the userland application stack usage,
> |especially for embedded linux.
> |
> |Currently you are only able to dump the main process/thread stack usage
> |which is showed in /proc/pid/status by the "VmStk" Value.  But you get no
> |information about the consumed stack memory of the the threads.
> |
> |There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which marks
> |the vm mapping where the thread stack pointer reside with "[thread stack
> |xxxxxxxx]".  xxxxxxxx is the maximum size of stack.  This is a value
> |information, because libpthread doesn't set the start of the stack to the
> |top of the mapped area, depending of the pthread usage.
> |
> |A sample output of /proc/<pid>/task/<tid>/maps looks like:
> |
> |08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
> |08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
> --------------------------
> No file to patch.  Skipping patch.
> patch: **** /tmp/poPjWncl : No such file or directory
> Patch procfs-provide-stack-information-for-threads-v08.patch does not apply (enforce with -f)
> 
> Yowza.  Not sure what makes it think there's an issue at line 20, looks to
> *me* like the actual patch starts on line 77.

patch version problem?  I'm not seeing an error there.

Applying patch procfs-provide-stack-information-for-threads-v08.patch
patching file Documentation/filesystems/proc.txt
patching file fs/exec.c
Hunk #1 succeeded at 1340 ([33moffset -4 lines[00m).
patching file fs/proc/array.c
patching file fs/proc/task_mmu.c
patching file include/linux/sched.h
Hunk #1 succeeded at 1486 ([33moffset 26 lines[00m).
patching file kernel/fork.c
Hunk #1 succeeded at 1094 ([33moffset -1 lines[00m).


> patch --version
patch 2.5.9

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
