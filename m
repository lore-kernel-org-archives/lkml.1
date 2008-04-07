Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYDGFay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYDGFay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 01:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYDGFar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 01:30:47 -0400
Received: from nn7.de ([85.214.94.156]:36538 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbYDGFaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 01:30:46 -0400
Subject: Re: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: "Carlos R\. Mafra" <crmafra2@gmail.com>,
       "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200804070120.29055.rjw@sisk.pl>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <200804062301.51490.rjw@sisk.pl>
	 <20080406220756.GA20175@localhost.ift.unesp.br>
	 <200804070120.29055.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Apr 2008 07:30:40 +0200
Message-Id: <1207546240.5962.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 01:20 +0200, Rafael J. Wysocki wrote:
> On Monday, 7 of April 2008, Carlos R. Mafra wrote:
> > On Sun  6.Apr'08 at 23:01:50 +0200, Rafael J. Wysocki wrote:
> > > On Saturday, 5 of April 2008, Carlos R. Mafra wrote:
> > > > On Fri  4.Apr'08 at 13:41:45 -0700, Pallipadi, Venkatesh wrote:
> > > > 
> > > > > >>> Can you try the latest git and see whether this still is a problem?
> > > > > >>
> > > > > >>I've just updated to latest git, but it may take some time for it 
> > > > > >>to happen again (the first 3 boots were okay). Last time it happened
> > > > > >>with 2.6.25-rc7-00149-gaf8be4e (I checked now). 
> > > > > >>
> > > > > >>Do you have reasons to believe this issue was fixed since then?
> > > > > >
> > > > > >Yes. I think the patch here should have fixed the problem....
> > > > > >Patch : http://marc.info/?l=linux-kernel&m=120674502201007&w=4
> > > > > >
> > > > > 
> > > > > Hmmmm.... Looking at latest git,
> > > > > The above patch is not yet in git. Can you please apply the above patch
> > > > > and see whether do you still see the problem.....
> > > > 
> > > > OK, I will apply it manually and test it.
> > > > 
> > > > For the record: yesterday my laptop hang at boot with v2.6.25-rc8-139-ge315c12
> > > > (without the above patch).
> > > 
> > > Carlos, please add yourself to the CC list at
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10093
> > 
> > Rafael, I added myself to bug 10117 instead of 10093.
> > 
> > I am sorry about this confusion, but the References: to
> > both bug 10093 and 10117 are this email from Soeren
> > http://lkml.org/lkml/2008/2/23/263 (and this is how I got
> > to this thread)
> > 
> > That is the hang which happens in my laptop with latest git.
> > You can check that by looking at this picture I took while
> > my laptop was hung http://www.ift.unesp.br/users/crmafra/dsc04673.jpg
> > 
> > However you closed bug 10117, but that is not fixed for me so I am 
> > going to reopen it if you don't mind.
> 
> OK
> 
> Well, perhaps we should mark bug #10093 as a duplicate of bug #10117 or
> vice versa.  Soeren, are they really different?

No idea... All I can tell is that I could not trigger the 
supports 8 throttling states hang anymore since quite a while... It
looks like it got harder to trigger for Carlos too... maybe he could try
to disable CONFIG_CPUIDLE and check if it is at least CPUIDLE related?

Soeren
