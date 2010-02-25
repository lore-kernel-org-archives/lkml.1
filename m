Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259Ab0BYWXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:23:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:47937 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934190Ab0BYWW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:22:58 -0500
Date: Fri, 26 Feb 2010 09:22:18 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: linux-security-module@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org, oleg@redhat.com, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] TOMOYO: Protect find_task_by_vpid() with RCU.
In-Reply-To: <201002250819.o1P8JPwQ063834@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.1002260921350.23539@tundra.namei.org>
References: <201002240034.o1O0YoMd068517@www262.sakura.ne.jp> <alpine.LRH.2.00.1002251056240.13762@tundra.namei.org> <201002250013.o1P0DHml057484@www262.sakura.ne.jp> <alpine.LRH.2.00.1002251413160.14411@tundra.namei.org>
 <201002250819.o1P8JPwQ063834@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Tetsuo Handa wrote:

> I see. Explanation is in commit d4581a239a40319205762b76c01eb6363f277efa
> "sys: Fix missing rcu protection for __task_cred() access".
> Thus, I think below comment should be sufficient.
> --------------------
> [PATCH] TOMOYO: Protect find_task_by_vpid() with RCU.
> 
> Holding tasklist_lock is no longer sufficient for find_task_by_vpid().
> Explicit rcu_read_lock() is required.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

The audit code still looks like it needs to be updated.

-- 
James Morris
<jmorris@namei.org>
