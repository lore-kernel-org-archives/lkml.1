Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYLCDqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYLCDqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYLCDqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:46:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34203 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYLCDqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:46:36 -0500
Subject: Re: [RFC PATCH 0/3] A couple of feature requests to the unified
	trace  buffer
From: Steven Rostedt <srostedt@redhat.com>
To: Jiaying Zhang <jiayingz@google.com>
Cc: linux-kernel@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>, Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <5df78e1d0812021935h56c2e21am88477ad44a57ec78@mail.gmail.com>
References: <5df78e1d0812021652w74c968bboba5e6457059b569b@mail.gmail.com>
	 <1228272731.4886.26.camel@localhost.localdomain>
	 <5df78e1d0812021935h56c2e21am88477ad44a57ec78@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 02 Dec 2008 22:45:44 -0500
Message-Id: <1228275944.4886.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-12-02 at 19:35 -0800, Jiaying Zhang wrote:

> > If you check out my git tree:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> >
> >  branch: tip/devel
> >
> > You will see that I started writing code to handle "splice". I have a
> > retarded version that works right now (using the term "works" loosely
> > here).
> 
> This is great! I just checked out your git tree and will take a close look.
> Do you plan to support mmap other than splice in the unified trace buffer?
> I am not familiar with splice. Is it superior?
> 
> >
> > Also, most of our development is done in the Ingo's tip tree:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> >
> >  branch: master
> >
> > I see in the patches that you based this on 2.6.26.2? Not sure which
> > version of the ring buffer you are using, but there has been lots of
> > improvements to it already.
> 
> My patches are based on the unified ring buffer code I checked out
> from git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> a week ago. I saw you posted two new patches today. I haven't merged
> my patches with them yet.

OK, I was nervous by seeing in your patches:

Index: linux-2.6.26.2/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.26.2.orig/include/asm-generic/vmlinux.lds.h
2008-11-25 11:32:26.000000000 -0800
+++ linux-2.6.26.2/include/asm-generic/vmlinux.lds.h    2008-11-25


My splice code is not in git yet. I can put it there tonight. But the
ring buffer code needed to work with splice is there. The splice work is
at the ftrace level, but you probably could use the same as well.

-- Steve


