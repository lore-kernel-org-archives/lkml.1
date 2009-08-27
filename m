Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbZH0Gde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbZH0Gde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 02:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZH0Gdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 02:33:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49486 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZH0Gdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 02:33:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Aug 2009 15:31:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-Id: <20090827153144.e55128e8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A96250C.3060802@ct.jp.nec.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
	<20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
	<4A96250C.3060802@ct.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 15:17:48 +0900
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > In the newest mmotom, my S14nfslock hangs up. (x86-64/Fedora10)
> > 
> > On Mon, 24 Aug 2009 16:28:30 -0700
> > akpm@linux-foundation.org wrote:
> > 
> >> ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
> >> do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
> > 
> > bisected. following 2 patches for filtering SIGCHLD cause hang (for my environ).
> > 
> >> do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
> >> do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
> > 
> > And, Hmm, I'm not bisected yet but..
> > ==
> > [root@bluextal kamezawa]# ps -ef
> > UID        PID  PPID  C STIME TTY          TIME CMD
> > 
> > 
> > Signal 11 (SEGV) caught by ps (procps version 3.2.7).
> > Please send bug reports to <feedback@lists.sf.net> or <albert@users.sf.net>
> > ==
> > 
> > 'ps -ef' gets SEGV. still digging.
> 
> This patch will fix the issue.
> http://lkml.org/lkml/2009/8/25/47
> 

Thanks, 'ps' is fixed.

-Kame

