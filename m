Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYBASUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYBASUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYBASUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:20:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbYBASUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:20:38 -0500
Date: Fri, 1 Feb 2008 10:19:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Alexey Dobriyan <adobriyan@sw.ru>,
       Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] hrtimer_nanosleep: fix *rmtp handling
Message-Id: <20080201101918.52fa4c50.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802011616000.9204@apollo.tec.linutronix.de>
References: <20080201133758.GA25623@tv-sign.ru>
	<20080201142905.GA25833@tv-sign.ru>
	<alpine.LFD.1.00.0802011616000.9204@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008 16:16:50 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 1 Feb 2008, Oleg Nesterov wrote:
> 
> > (Andrew, the same patch, but re-diffed without the first one in series).
> 
> I pick them up and feed them through hrtimer.git, once all bugs are
> shaken out :)

Please remember that
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git#mm
contains the "hrtimers: use hrtimers so that msleep() sleeps for the
requested time" patch which kills my USB setup.

