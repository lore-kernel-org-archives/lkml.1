Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYDFWIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYDFWIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 18:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYDFWIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 18:08:36 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:46223 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbYDFWIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 18:08:35 -0400
Date: Sun, 6 Apr 2008 19:07:56 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
Message-ID: <20080406220756.GA20175@localhost.ift.unesp.br>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <924EFEDD5F540B4284297C4DC59F3DEED0EEC6@orsmsx423.amr.corp.intel.com> <20080405130520.GA8959@localhost.ift.unesp.br> <200804062301.51490.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804062301.51490.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun  6.Apr'08 at 23:01:50 +0200, Rafael J. Wysocki wrote:
> On Saturday, 5 of April 2008, Carlos R. Mafra wrote:
> > On Fri  4.Apr'08 at 13:41:45 -0700, Pallipadi, Venkatesh wrote:
> > 
> > > >>> Can you try the latest git and see whether this still is a problem?
> > > >>
> > > >>I've just updated to latest git, but it may take some time for it 
> > > >>to happen again (the first 3 boots were okay). Last time it happened
> > > >>with 2.6.25-rc7-00149-gaf8be4e (I checked now). 
> > > >>
> > > >>Do you have reasons to believe this issue was fixed since then?
> > > >
> > > >Yes. I think the patch here should have fixed the problem....
> > > >Patch : http://marc.info/?l=linux-kernel&m=120674502201007&w=4
> > > >
> > > 
> > > Hmmmm.... Looking at latest git,
> > > The above patch is not yet in git. Can you please apply the above patch
> > > and see whether do you still see the problem.....
> > 
> > OK, I will apply it manually and test it.
> > 
> > For the record: yesterday my laptop hang at boot with v2.6.25-rc8-139-ge315c12
> > (without the above patch).
> 
> Carlos, please add yourself to the CC list at
> http://bugzilla.kernel.org/show_bug.cgi?id=10093

Rafael, I added myself to bug 10117 instead of 10093.

I am sorry about this confusion, but the References: to
both bug 10093 and 10117 are this email from Soeren
http://lkml.org/lkml/2008/2/23/263 (and this is how I got
to this thread)

That is the hang which happens in my laptop with latest git.
You can check that by looking at this picture I took while
my laptop was hung http://www.ift.unesp.br/users/crmafra/dsc04673.jpg

However you closed bug 10117, but that is not fixed for me so I am 
going to reopen it if you don't mind.

By the way, thanks for all your effort to track down these regressions.
