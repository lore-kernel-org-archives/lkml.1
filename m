Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbZAIUbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbZAIUbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbZAIUbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:31:08 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:51608 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbZAIUbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:31:06 -0500
Date: Fri, 09 Jan 2009 15:30:56 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] kprobes: check CONFIG_FREEZER instead of CONFIG_PM
In-reply-to: <20090107121659.GA16268@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Cheng Renquan <crquan@gmail.com>
Message-id: <alpine.LFD.2.00.0901091530090.16697@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200901062112.29227.rjw@sisk.pl> <200901062115.33286.rjw@sisk.pl>
 <20090107121659.GA16268@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Check CONFIG_FREEZER instead of CONFIG_PM because kprobe booster
> > depends on freeze_processes() and thaw_processes() when CONFIG_PREEMPT=y.
> > 
> > This fixes a linkage error which occurs when CONFIG_PREEMPT=y, CONFIG_PM=y
> > and CONFIG_FREEZER=n.
> > 
> > Reported-by: Cheng Renquan <crquan@gmail.com>
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  arch/ia64/kernel/kprobes.c |    2 +-
> >  arch/x86/kernel/kprobes.c  |    2 +-
> >  kernel/kprobes.c           |    2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> looks good, the x86 bits:
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

man, we have too many config options:-)

applied.
thanks,
Len Brown, Intel Open Source Technology Center


