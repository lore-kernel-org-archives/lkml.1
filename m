Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0CBWV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:21:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:33670 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0CBWVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:21:55 -0500
Date: Wed, 3 Mar 2010 09:20:21 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: linux-security-module@vger.kernel.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, oleg@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, eparis@redhat.com
Subject: Re: [PATCH] audit: Protect find_task_by_vpid() with RCU.
In-Reply-To: <201002260346.o1Q3kUmg005596@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.1003030919540.14492@tundra.namei.org>
References: <201002260346.o1Q3kUmg005596@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Tetsuo Handa wrote:

> [PATCH] audit: Protect find_task_by_vpid() with RCU.
> 
> Holding tasklist_lock is no longer sufficient for find_task_by_vpid().
> Explicit rcu_read_lock() is required.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> 

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
