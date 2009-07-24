Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZGXPfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZGXPfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZGXPfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:35:03 -0400
Received: from www.tglx.de ([62.245.132.106]:52143 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZGXPfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:35:02 -0400
Date: Fri, 24 Jul 2009 17:34:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: sen wang <wangsen.linux@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       akpm@linux-foundation.org, kernel@kolivas.org, npiggin@suse.de,
       arjan@infradead.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
In-Reply-To: <454c71700907240807t5b682e7cv52534f41d3be961a@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0907241721040.2936@localhost.localdomain>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>  <1248437670.6987.26.camel@twins>  <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>  <1248441290.6987.52.camel@twins>  <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
  <1248442415.6987.56.camel@twins>  <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>  <1248443656.6987.61.camel@twins>  <454c71700907240704o32dcdeb3v57845eb9472dd04c@mail.gmail.com>  <1248446909.6987.110.camel@twins>
 <454c71700907240807t5b682e7cv52534f41d3be961a@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009, sen wang wrote:
> 2009/7/24 Peter Zijlstra <peterz@infradead.org>:
> > On Fri, 2009-07-24 at 22:04 +0800, sen wang wrote:
> >
> >> just one question:
> >> if cpu is free and there is running state task, how you do?
> >> schedule the task up? or schedule idle task up?
> >
> > Well, when an RT group is over the bandwidth limit I don't consider them
> > runnable. Therefore, failing to find any other tasks, we run the idle
> > task.
> >
> 
> you havn't anwser the question: if cpu is free, should we  schedule the
> running state task or idle task?

Peter explained how it's implemented and why he considers it to be
correct and that it can be disabled.

> face the error and fix it! ok?

Can you please stop yelling at Peter? 

He politely answered your questions. Have you even thought about his
answers before shouting "error" ? Also be aware that you can yell "fix
it" as often as you want, all you are achieving is an entry in a
couple of /dev/null procmail rules.

Please read http://www.tux.org/lkml/#s3-12 before you answer again.

Thanks,

	tglx
