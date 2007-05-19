Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbXESHH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbXESHH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 03:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXESHHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 03:07:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbXESHHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 03:07:15 -0400
Date: Sat, 19 May 2007 00:04:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mattia Dongili <malattia@linux.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after
 STR
Message-Id: <20070519000413.75badb6f.akpm@linux-foundation.org>
In-Reply-To: <20070519064829.GA15518@inferi.kami.home>
References: <20070518071523.GA3195@inferi.kami.home>
	<20070518002240.bc08e811.akpm@linux-foundation.org>
	<20070519064829.GA15518@inferi.kami.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 15:48:29 +0900 Mattia Dongili <malattia@linux.it> wrote:

> On Fri, May 18, 2007 at 12:22:40AM -0700, Andrew Morton wrote:
> > On Fri, 18 May 2007 16:15:24 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > 
> > > Hello,
> > > 
> > > After finally catching fw-{ohci,core} to be problematic during resume,
> > > I'm now experiencing an immediate resume after suspending.
> > > 
> > > 2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
> > > kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
> > > 2.6.21-rc6-mm* after the cpuidle fixes).
> > > 
> > > my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
> > > and a str cycle with PM_DEBUG=y:
> > > http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt
> ...
> > > Any idea where to start from? (bisecting is ok, but it'll take some
> > > time...)
> > 
> > Bisecting isn't that bad ;) I'd pick git-acpi.patch as the starting point.
> 
> ok, git-acpi.patch is not the bad boy :)
> Anyway what we have is a regression in 2.6.22-rc1 since the laptop can't
> suspend (it sits on the "Stopping tasks" console screen) while 2.6.21
> can.
> I'm now bisecting this, will come to -mm1 later when done with this one.

OK, thanks.

> Who is the regression-guy?

Len, usually ;)    But I think you meant Michal, cc'ed here.
