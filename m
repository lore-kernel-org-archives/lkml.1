Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYE3DRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYE3DRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 23:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYE3DRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 23:17:03 -0400
Received: from xenotime.net ([66.160.160.81]:59457 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752104AbYE3DRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 23:17:01 -0400
Date: Thu, 29 May 2008 20:30:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Jackson <pj@sgi.com>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080529203042.19f76f09.rdunlap@xenotime.net>
In-Reply-To: <20080529212211.0e794c81.pj@sgi.com>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
	<20080529205344.4ba1efdb.pj@sgi.com>
	<483F6367.1040701@cn.fujitsu.com>
	<20080529212211.0e794c81.pj@sgi.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 21:22:11 -0500 Paul Jackson wrote:

> Miao wrote:
> > I check kernel/cpuset.c and find many static functions with "/**" comment.
> > So I want to remove the special commenting convention for them.
> 
> Right you are.  Offhand, in kernel/cpuset.c, I see:
> 
>     static int cpuset_test_cpumask(struct task_struct *tsk,
>     static void cpuset_change_cpumask(struct task_struct *tsk,
>     static int update_cpumask(struct cpuset *cs, char *buf)
>     static void cpuset_do_move_task(struct task_struct *tsk,
>     static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
> 
> all having "/**" header comments.  I would be glad to Ack a patch
> from you to fix such comments.  Thank-you.


Uh.. We strongly want non-static functions to be documented via kernel-doc.
For static functions, it's up to the maintainer/developer whether to do that
or not.  But if the functions already have kernel-doc, there's no strong
reason to remove it.  And these look good currently, so I see no
good reason to change them.



---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
