Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZF3Uj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZF3Uj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZF3Ujw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:39:52 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:60029 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbZF3Ujv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:39:51 -0400
Message-ID: <4A4A77F1.4010405@oracle.com>
Date: Tue, 30 Jun 2009 13:39:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>	<54770.1246392952@turing-police.cc.vt.edu>	<4A4A7364.1090108@oracle.com> <20090630133550.bf34a0ba.akpm@linux-foundation.org>
In-Reply-To: <20090630133550.bf34a0ba.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A4A77F3.0078:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 30 Jun 2009 13:19:48 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> Valdis.Kletnieks@vt.edu wrote:
> 
> (I wasn't cc'ed?)

mm-commits but not you... (from Valdis)

>>> On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
>>>> The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to
>>> This dies with quilt 0.44, thusly:
>>>
>>> Applying patch procfs-provide-stack-information-for-threads-v08.patch
>>> can't find file to patch at input line 20
>>> Perhaps you used the wrong -p or --strip option?
>>> The text leading up to this was:
>>> --------------------------
>>> |From: Stefani Seibold <stefani@seibold.net>
>>> |
>>> |A patch to give a better overview of the userland application stack usage,
>>> |especially for embedded linux.
>>> |
>>> |Currently you are only able to dump the main process/thread stack usage
>>> |which is showed in /proc/pid/status by the "VmStk" Value.  But you get no
>>> |information about the consumed stack memory of the the threads.
>>> |
>>> |There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which marks
>>> |the vm mapping where the thread stack pointer reside with "[thread stack
>>> |xxxxxxxx]".  xxxxxxxx is the maximum size of stack.  This is a value
>>> |information, because libpthread doesn't set the start of the stack to the
>>> |top of the mapped area, depending of the pthread usage.
>>> |
>>> |A sample output of /proc/<pid>/task/<tid>/maps looks like:
>>> |
>>> |08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
>>> |08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
> 
> The next line is:
> 
> a7d12000-a7d13000 ---p 00000000 00:00 0
> 
> And I bet stupid patch(1) saw that "---" and decided that it was the
> start of a diff.
> 
> Try adding `-u' to the patch(1) command?
> 
> I use something like
> 
> 	patch -u -f -p1 --fuzz=1 -s

Yes, my .quiltrc file contains -u for QUILT_PATCH_OPTS.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
