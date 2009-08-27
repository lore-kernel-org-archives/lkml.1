Return-Path: <linux-kernel-owner+w=401wt.eu-S1751248AbZH0GTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbZH0GTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 02:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZH0GTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 02:19:16 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60283 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZH0GTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 02:19:15 -0400
Message-ID: <4A96250C.3060802@ct.jp.nec.com>
Date: Thu, 27 Aug 2009 15:17:48 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: mmotm 2009-08-24-16-24 uploaded
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org> <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> In the newest mmotom, my S14nfslock hangs up. (x86-64/Fedora10)
> 
> On Mon, 24 Aug 2009 16:28:30 -0700
> akpm@linux-foundation.org wrote:
> 
>> ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
>> do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
> 
> bisected. following 2 patches for filtering SIGCHLD cause hang (for my environ).
> 
>> do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
>> do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
> 
> And, Hmm, I'm not bisected yet but..
> ==
> [root@bluextal kamezawa]# ps -ef
> UID        PID  PPID  C STIME TTY          TIME CMD
> 
> 
> Signal 11 (SEGV) caught by ps (procps version 3.2.7).
> Please send bug reports to <feedback@lists.sf.net> or <albert@users.sf.net>
> ==
> 
> 'ps -ef' gets SEGV. still digging.

This patch will fix the issue.
http://lkml.org/lkml/2009/8/25/47

Thanks,
Hiroshi
