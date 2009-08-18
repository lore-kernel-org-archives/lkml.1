Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZHRWkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZHRWkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbZHRWkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:40:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbZHRWkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:40:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: suspend tree build failure
Date: Wed, 19 Aug 2009 00:40:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090818183049.8bde1ee6.sfr@canb.auug.org.au> <200908182343.32375.rjw@sisk.pl> <20090818221301.GA20676@linux-sh.org>
In-Reply-To: <20090818221301.GA20676@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908190040.50949.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 August 2009, Paul Mundt wrote:
> On Tue, Aug 18, 2009 at 11:43:32PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday 18 August 2009, Stephen Rothwell wrote:
> > > Hi Rafael,
> > 
> > Hi,
> > 
> > > Today's linux-next build (i386 defconfig) failed like this:
> > > 
> > > drivers/base/power/main.c: In function 'device_pm_init':
> > > drivers/base/power/main.c:59: error: 'struct dev_pm_info' has no member named 'lock'
> > 
> > Argh, that line shouldn't even be there.
> > 
> > > Caused by commit ea8e84f27325d9ddc7692f728a10e0a22cd59f52 ("PM: Introduce
> > > core framework for run-time PM of I/O devices (rev. 17)") from the
> > > suspend tree.  The i386 defconfig does not have CONFIG_PM_RUNTIME set but
> > > does have CONFIG_PM_SLEEP=y ...
> > > 
> > > I have reverted that commit for today.
> > > 
> > > When you add a new CONFIG variable, it is worth doing test builds both
> > > with it turned on and turned off ...
> > 
> > I tested it, but I broke the patch afterwards by mistake. :-(
> > 
> > Sorry for the trouble, I've just pushed an updated tree.
> > 
> Argh, and rebased in the process, again. This is now the second time in
> as many days this has been rebased, meaning I have to throw away my topic
> branch and re-create. I thought this was going to remain stable? I would
> like the SH runtime PM code to get some coverage in -next, but I can't
> merge it in to my tree if the suspend tree keeps rebasing every day.

Well, my linux-next branch is not to guaranteed to be stable, just like the
entire linux-next tree.

Once the patch stops making trouble, I'll move it into my for-linus branch,
which _is_ guaranteed not to be rebased (in fact it's never rebased).

I haven't done it yet exactly because of these build problems.  Please wait
for a couple of days more for things to settle down.

Best,
Rafael
