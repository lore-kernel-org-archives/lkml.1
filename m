Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXETGR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXETGR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759243AbXETGRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:17:50 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:42626 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679AbXETGRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:17:49 -0400
Date: Sun, 20 May 2007 15:14:08 +0900
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR
Message-ID: <20070520061408.GA3325@inferi.kami.home>
References: <20070518071523.GA3195@inferi.kami.home> <20070518002240.bc08e811.akpm@linux-foundation.org> <20070519064829.GA15518@inferi.kami.home> <20070519000413.75badb6f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519000413.75badb6f.akpm@linux-foundation.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc1-mm1-bisect i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 12:04:13AM -0700, Andrew Morton wrote:
> On Sat, 19 May 2007 15:48:29 +0900 Mattia Dongili <malattia@linux.it> wrote:
> 
> > On Fri, May 18, 2007 at 12:22:40AM -0700, Andrew Morton wrote:
> > > On Fri, 18 May 2007 16:15:24 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > > 
> > > > Hello,
> > > > 
> > > > After finally catching fw-{ohci,core} to be problematic during resume,
> > > > I'm now experiencing an immediate resume after suspending.
> > > > 
> > > > 2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
> > > > kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
> > > > 2.6.21-rc6-mm* after the cpuidle fixes).
> > > > 
> > > > my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
> > > > and a str cycle with PM_DEBUG=y:
> > > > http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt
> > ...
> > > > Any idea where to start from? (bisecting is ok, but it'll take some
> > > > time...)
> > > 
> > > Bisecting isn't that bad ;) I'd pick git-acpi.patch as the starting point.
> > 
> > ok, git-acpi.patch is not the bad boy :)

but very very close:
acpi-driver-model-flags-and-platform_enable_wake.patch

cheers
-- 
mattia
:wq!
