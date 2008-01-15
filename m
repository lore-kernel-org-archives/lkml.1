Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYAOXlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYAOXlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYAOXlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:41:39 -0500
Received: from mail001.aei.ca ([206.123.6.130]:38939 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYAOXli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:41:38 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Date: Tue, 15 Jan 2008 18:41:34 -0500
User-Agent: KMail/1.9.7
Cc: Matthew <jackdachef@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>
References: <47841C41.4060401@zytor.com> <200801141716.38380.edt@aei.ca> <20080115220952.GD2665@elte.hu>
In-Reply-To: <20080115220952.GD2665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151841.35714.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On January 15, 2008, Ingo Molnar wrote:
> 
> * Ed Tomlinson <edt@aei.ca> wrote:
> 
> > This is _not_ a regression.  This has been occuring for ages here.  A 
> > backport of this fix to 2.6.23 would be a very good thing - IMHO its 
> > something that should go into stable asap.
> 
> the problem is that this bug was only present in x86.git. I.e. neither 
> 2.6.24 nor 2.6.23 has this particular bug.
> 
> perhaps something else in x86.git fixed your box, but this 
> x86.git-specific hang 'took over its place', and now that it got fixed, 
> you've got a working box? In any case, please monitor your box, it might 
> still lock up the same way it did previously ...

I am now testing with a .24-rc7+fix  kernel.  So far so good.  Running gentoo's 32 bit
firefox with flash 9 is a good way to trigger the problem here as is running Delftship (freeship)
under wine.  The problem is usually worst with a fully preemptive kernel.  I have been using both on 
a kernel with preempt and have an uptime of 22 hours - this is really good.   I have rarely been able 
to get this much uptime using these apps.  If it manages to run for a few more days without a lockup 
it would really be worth trying to figure out what in .24 fixes the problem...

THANKS!
Ed Tomlinson
