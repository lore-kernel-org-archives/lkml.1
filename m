Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbZJIHXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbZJIHXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZJIHXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:23:31 -0400
Received: from www.tglx.de ([62.245.132.106]:56946 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbZJIHXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:23:30 -0400
Date: Fri, 9 Oct 2009 09:22:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: wu Jianfeng <stormplayer@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: the select system call's implementation may have some bug in
 preempt kernel mode
In-Reply-To: <a5b3ea7b0910090011k7558faf2p4de252875587291e@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0910090921530.9428@localhost.localdomain>
References: <a5b3ea7b0910082242s6ce8275dr7f962ce526e55cd2@mail.gmail.com>  <a5b3ea7b0910082250o659d4fd3l8f319fd6bde24f3d@mail.gmail.com>  <alpine.LFD.2.00.0910090849400.9428@localhost.localdomain>
 <a5b3ea7b0910090011k7558faf2p4de252875587291e@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, wu Jianfeng wrote:

> > Right, but that does not cause the task to be scheduled out for ever.
> 
> I don't know why ???
> the process state is TASK_INTERRUPTIBLE, and was scheduled out.
> 
> if no one wake up it or any signals received, it will sleep for ever.
> The process does't entered any file's wait queue at that point, so I
> am sure no one will wake up it.
> 
> Am i right?

No. Did you actually read, what I wrote further down ?
 
> > When the task is scheduled out at that point, it is not
> > deactivated. It is preempted, which means it stays on the run queue
> > despite of the TASK_INTERRUPTIBLE state and is scheduled back in later
> > on.

Thanks,

	tglx
