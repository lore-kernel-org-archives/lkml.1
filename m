Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYE3CWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYE3CWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 22:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYE3CWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 22:22:17 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47739 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752922AbYE3CWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 22:22:16 -0400
Date: Thu, 29 May 2008 21:22:11 -0500
From: Paul Jackson <pj@sgi.com>
To: miaox@cn.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080529212211.0e794c81.pj@sgi.com>
In-Reply-To: <483F6367.1040701@cn.fujitsu.com>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
	<20080529205344.4ba1efdb.pj@sgi.com>
	<483F6367.1040701@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miao wrote:
> I check kernel/cpuset.c and find many static functions with "/**" comment.
> So I want to remove the special commenting convention for them.

Right you are.  Offhand, in kernel/cpuset.c, I see:

    static int cpuset_test_cpumask(struct task_struct *tsk,
    static void cpuset_change_cpumask(struct task_struct *tsk,
    static int update_cpumask(struct cpuset *cs, char *buf)
    static void cpuset_do_move_task(struct task_struct *tsk,
    static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)

all having "/**" header comments.  I would be glad to Ack a patch
from you to fix such comments.  Thank-you.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
