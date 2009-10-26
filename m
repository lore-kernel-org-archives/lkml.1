Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbZJZOeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbZJZOeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 10:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZJZOeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 10:34:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35815 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZJZOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 10:34:05 -0400
Subject: Re: [PATCH -v5 02/11] MIPS: add mips_timecounter_read() to get
 high precision timestamp
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: wuzhangjin@gmail.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1256567108.5642.165.camel@falcon>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <028867b99ec532b84963a35e7d552becc783cafc.1256483735.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <1256565667.26028.257.camel@gandalf.stny.rr.com>
	 <1256567108.5642.165.camel@falcon>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 10:34:06 -0400
Message-Id: <1256567646.26028.260.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 22:25 +0800, Wu Zhangjin wrote:
> Hi,
> 
> On Mon, 2009-10-26 at 10:01 -0400, Steven Rostedt wrote:
> [...]
> > Some patches touch core tracing code, and some are arch specific. Now
> > the question is how do we go. I prefer that we go the path of the
> > tracing tree (easier for me to test).
> 
> Just coped with the feedbacks from Frederic Weisbecker.
> 
> I will rebase the whole patches to your git repo(the following one?) and
> send them out as the -v6 revision:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/tracing/core

Actually, I always base off of tip itself. Don't use mine. Use this one:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git  tracing/core

Then we will stay in sync.

> 
> >  But every patch that touches MIPS
> > arch, needs an Acked-by from the MIPS maintainer. Which I see is Ralf
> > (on the Cc of this patch set.)
> > 
> 
> Looking forward to the feedback from Ralf, Seems he is a little busy.
> and also looking forward to the testing result from the other MIPS
> developers, so, we can ensure ftrace for MIPS really function!
> 
> Welcome to clone this branch and test it:
> 
> git://dev.lemote.com/rt4ls.git  linux-mips/dev/ftrace-upstream

I already have your repo as a remote ;-)

> 
> And this document will tell you how to play with it:
> Documentation/trace/ftrace.txt

Did you add to it?

Thanks,

-- Steve


