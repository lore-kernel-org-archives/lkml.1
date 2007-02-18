Return-Path: <linux-kernel-owner+w=401wt.eu-S1161150AbXBRIgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161150AbXBRIgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 03:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161152AbXBRIgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 03:36:51 -0500
Received: from www.osadl.org ([213.239.205.134]:59031 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161150AbXBRIgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 03:36:50 -0500
Subject: Re: 2.6.20-git13 kernel BUG at
	/mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Alex Riesen <fork0@users.sourceforge.net>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <6bffcb0e0702171441i6ac69ac0yb1c46dbf8f43dc2e@mail.gmail.com>
References: <45D61632.1020105@googlemail.com>
	 <1171660939.30834.102.camel@localhost.localdomain>
	 <20070217144752.GA2503@steel.home>
	 <1171725257.30834.120.camel@localhost.localdomain>
	 <20070217164652.GA2579@steel.home>
	 <6bffcb0e0702171441i6ac69ac0yb1c46dbf8f43dc2e@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 09:41:39 +0100
Message-Id: <1171788100.30834.169.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 23:41 +0100, Michal Piotrowski wrote:
> sudo cat /var/log/messages | grep Idle
> Feb 17 17:35:34 bitis-gabonica kernel: Idle: local softirq pending:
> 0020<6>hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache,
> UDMA(33)
> Feb 17 19:20:01 bitis-gabonica kernel: Idle: local softirq pending:
> 0020<3>Idle: local softirq pending: 0020<3>Idle: local softirq
> pending: 0020<7>PM: Removing info for No Bus:vcs7>
>
> I can confirm that this is ICH5 SATA controller problem.

The arch/i386/kernel/process.c part of the patch should apply to 2.6.20
as well. Can you check if the problem is there too ?

	tglx


