Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYFZITG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYFZITG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbYFZISl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:18:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbYFZISh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:18:37 -0400
Date: Thu, 26 Jun 2008 01:17:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86 ACPI: normalize segment descriptor register on
 resume
Message-Id: <20080626011716.e8c412dd.akpm@linux-foundation.org>
In-Reply-To: <200806252217.27059.rjw@sisk.pl>
References: <200806242303.49498.rjw@sisk.pl>
	<20080624214610.GC18679@elf.ucw.cz>
	<20080625170126.GA2482@elte.hu>
	<200806252217.27059.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 22:17:26 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, 25 of June 2008, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@suse.cz> wrote:
> > 
> > > Acked-by: Pavel Machek <pavel@suse.cz>
> > > 
> > > If this could be sneaked into Ingo's tree for some automated testing, 
> > > that would be good.
> > 
> > sure - i have applied it to tip/out-of-tree. I'm equally nervous about 
> > this change - it affects every suspend+resume cycle that people do on 
> > those boxes which are working just fine currently.
> > 
> > btw., it would get a lot more coverage on my test-systems if this commit 
> > in tip/out-of-tree:
> > 
> > | commit 01259383c345d13b70efcc549439927ae64dc66d
> > | Author: David Brownell <david-b@pacbell.net>
> > | Date:   Fri May 16 10:12:36 2008 +0200
> > |
> > |     sleepy linux self-test
> > 
> > was upstream and if it was enabled more prominently, instead of hidden 
> > behind the rather obscure condition of:
> > 
> >   config PM_TEST_SUSPEND
> >         bool "Test suspend/resume and wakealarm during bootup"
> >         depends on SUSPEND && PM_DEBUG && RTC_LIB=y
> > 
> > and even then it needs certain other config options related to RTC_LIB 
> > to actually work during bootup.
> > 
> > As a result of all this obstruction, the automated testing i do, which 
> > builds and boots more than 1 random kernel per minute, will only run 
> > this self-test once every hour or so.
> > 
> > I dont mind if this option breaks boxes (that its purpose: it does the 
> > same thing that a real suspend+resume does and suspend+resume frequently 
> > breaks boxes), but right now it's all obscured so heavily which makes 
> > automated testing a lot harder than it should be.
> > 
> > it would be wonderful if this excellent suspend+resume self-test was 
> > upstream and was more prominent! :-)
> 
> I thought it was in linux-next, wasn't it?
> 

Len seems to think that Rafael seems to think that Ingo seems to think
that this patch broke one of his boxes.

Is it so?

Thanks.
