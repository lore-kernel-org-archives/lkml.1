Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYDOWza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYDOWza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYDOWzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:55:19 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:58640 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbYDOWzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:55:18 -0400
Date: Tue, 15 Apr 2008 19:54:11 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [Bug #10117] 2.6.25-current-git sometimes hangs on boot
	-dual-core Sony Vaio
Message-ID: <20080415225411.GA10041@localhost.ift.unesp.br>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Soeren Sonnenburg <kernel@nn7.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mark Lord <lkml@rtr.ca>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <200804152233.39079.rjw@sisk.pl> <20080415204500.GD1677@cs181133002.pp.htv.fi> <200804152303.45320.rjw@sisk.pl> <924EFEDD5F540B4284297C4DC59F3DEEE17FD4@orsmsx423.amr.corp.intel.com> <1208294294.7851.109.camel@localhost> <924EFEDD5F540B4284297C4DC59F3DEEE17FF1@orsmsx423.amr.corp.intel.com> <20080415212949.GG1677@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415212949.GG1677@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16.Apr'08 at  0:29:49 +0300, Adrian Bunk wrote:
> On Tue, Apr 15, 2008 at 02:24:35PM -0700, Pallipadi, Venkatesh wrote:
> >...
> > >> Both of them probabilistically hang early in the boot.
> > >> On both !CPUIDLE and hpet=disable seems to be working around the
> > >> problem.
> > >> Both are Core 2 Duo based with 64 bit kernel.
> > >> 
> > >> One difference I saw was that #10377 fails on battery. That may be
> > >> because when on battery CPUs may be running at lower freq during boot
> > >> and that is probably helping this problem in terms of timing.
> > >
> > >FWIW, this macbook pro1,1 has only a core 1 duo, so x86 == 32bit...
> > >Soeren
> > 
> > Sorry. When I said Core 2, I was referring to Carlos and his updates on
> > #10117.
> 
> This bug tracks Soerens problem.

Ok, sorry then. I know something odd happened with bug #10117 as
you so aggressively pointed out. 

In my defense I must say that I was about to report the hang with
"ACPI: Processor [CPU1] (supports 8 throttling states)" to lkml 
when I read Soeren's post in this list.
Then I did _not_ send the "me too" email and kept on following
what was going on.

So when I read that Soeren's bug was closed I wrote in the
bugzilla that I was still seeing the same issue, and that
I wanted to reopen it. I should not have done that and it
won't happen again.

> And the fact that Carlos and Mark discuss their different problems in 
> the same bug is just plain wrong.

You are saying it is a different problem, but it may be the same.
Sometimes I had to reboot 30+ times before the hang could happen!
And the last messages were _exactly_ the same.

But let's not argue about that, I just wanted to help by pointing
out that maybe the bug was being closed too early. In trying to
help I just caused more confusion, for which I appologize.

> We must learn to more aggressively point people at reporting their 
> issues in own bugs, instead of hijacking an already existing similar
> looking bug (that might be for a different issue).

I understand now, but you made me feel bad about it.


