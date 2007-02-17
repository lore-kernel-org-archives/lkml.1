Return-Path: <linux-kernel-owner+w=401wt.eu-S2993040AbXBQSUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993040AbXBQSUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993041AbXBQSUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:20:10 -0500
Received: from www.osadl.org ([213.239.205.134]:47998 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993040AbXBQSUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:20:08 -0500
Subject: Re: 2.6.20-git13 kernel BUG at
	/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alex Riesen <fork0@users.sourceforge.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070217164652.GA2579@steel.home>
References: <45D61632.1020105@googlemail.com>
	 <1171660939.30834.102.camel@localhost.localdomain>
	 <20070217144752.GA2503@steel.home>
	 <1171725257.30834.120.camel@localhost.localdomain>
	 <20070217164652.GA2579@steel.home>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 19:24:55 +0100
Message-Id: <1171736695.30834.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 17:46 +0100, Alex Riesen wrote:
> > Can you please apply the patch below, so we can at least see, which
> > softirq is pending. This should trigger independently of hrtimers and
> > dynticks. You can keep it compiled in and disable it at the kernel
> > commandline with "nohz=off" and / or "highres=off"
> 
> It did, only one time:
> 
> Idle: local softirq pending: 0020<6>USB Universal Host Controller Interface driver v3.0

0x20 is the TASKLET_SOFTIRQ. I have no idea yet, how this can happen.

Can you please check, if this happens when you add "nohz=off" to the
kernel command line.

	tglx





