Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYHJPw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYHJPw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYHJPwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:52:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:39523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbYHJPws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:52:48 -0400
Subject: Re: [Bug #11278] 2.6.27-rc2: Very odd top: '5124095h kthreadd'
	display
From: Peter Zijlstra <peterz@infradead.org>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <p8tt949h41ff647i9ga0fp3jhpvnllnj3t@4ax.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	 <cX_-nNkxKaF.A.WR.xCjnIB@albercik>
	 <otds94lkpmrooo1s9c0he3j3pral8fmojl@4ax.com>
	 <200808101457.26524.rjw@sisk.pl>
	 <p8tt949h41ff647i9ga0fp3jhpvnllnj3t@4ax.com>
Content-Type: text/plain
Date: Sun, 10 Aug 2008 17:52:38 +0200
Message-Id: <1218383558.10800.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 00:06 +1000, Grant Coady wrote:
> On Sun, 10 Aug 2008 14:57:26 +0200, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> >On Sunday, 10 of August 2008, Grant Coady wrote:
> >> On Sun, 10 Aug 2008 00:43:52 +0200 (CEST), "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >> 
> >> >This message has been generated automatically as a part of a report
> >> >of recent regressions.
> >> >
> >> >The following bug entry is on the current list of known regressions
> >> >from 2.6.26.  Please verify if it still should be listed and let me know
> >> >(either way).
> >> >
> >> >
> >> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11278
> >> >Subject		: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
> >> >Submitter	: Grant Coady <grant_lkml@dodo.com.au>
> >> >Date		: 2008-08-07 7:03 (3 days old)
> >> >References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4
> >> >
> >> 
> >> Patch from Peter Z. fixed it for me, so it may be removed now.
> >
> >Is the patch in the mainline already?
> 
> No idea.
> >
> >If not, can you please provide me with a link to the patch?
> 
> root@twins:/mnt/build/linux-2.6# git show 4a273f209cc95d148f79b4c96d3d03997b44ffda | patch -p1 -R
> patching file kernel/sched_clock.c
> 
> Is what I have from Peter's email.  Added Peter Z. to the Cc:
> 
> Grant.

its part of tip/sched/clock

except for that one patch that got reverted. I'll work on getting it
upstream once Ingo is back next week.

