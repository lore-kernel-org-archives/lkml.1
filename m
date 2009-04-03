Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbZDCK3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbZDCK3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZDCK3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:29:15 -0400
Received: from www.tglx.de ([62.245.132.106]:43068 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZDCK3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:29:14 -0400
Date: Fri, 3 Apr 2009 12:27:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: System deadlock on 2.6.24-rt20
In-Reply-To: <3efb10970904030248t39a13176led25b9dc7ff9383c@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904031226500.12916@localhost.localdomain>
References: <3efb10970904030248t39a13176led25b9dc7ff9383c@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Remy Bohmer wrote:

> Hello All,
> 
> We encountered a nasty system lockup on an X86 system running
> 2.6.24.7-rt20. (Intel Core2Duo system)
> What happens is that the system freezes completely after some time.
> After a lot of testing we are now able to reproduce this problem
> within 5 minutes of testing.
> 
> The backtrace was not printed to the serial terminal, but when we
> accidentally used the VGA
> terminal the backtrace was there. So we used/hacked the earlyprintk
> mechanism to get the logging out.
> 
> Does anybody recognise these backtraces? And if so, is there a fix for
> it already?

http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.24.7-rt27.bz2

Thanks,

	tglx
