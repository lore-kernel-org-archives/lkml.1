Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZFHNW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZFHNW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZFHNWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:22:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44430 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZFHNWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:22:47 -0400
Date: Mon, 8 Jun 2009 15:22:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608132235.GC13214@elte.hu>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl> <20090608065419.GA13568@elte.hu> <200906081330.50045.rjw@sisk.pl> <20090608130509.GA3272@elte.hu> <20090608131159.GA15100@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608131159.GA15100@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Jun 08, 2009 at 03:05:09PM +0200, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > Well, we've been discussing it for quite a while and since more 
> > > and more people are interested, I'm giving it a high priority.
> > 
> > Cool. I think that if within a few years we could achieve that every 
> > default distro (both on desktops and on servers) triggers PM 
> > functionality runtime on common hardware, we'd both have lower power 
> > consumption in general, and we'd have more robust suspend-resume 
> > code as well.
> 
> The difficulty is in determining when it's viable to autosuspend a 
> given device. There's a limit to how much we can determine purely 
> from kernel state (for instance, we could suspend ahci when 
> there's no pending disk access, but we'd lose hotplug 
> notifications) so there's going to have to be some level of 
> userspace policy determination. Having the infrastructure in the 
> kernel is an important part of this, but there'll be some distance 
> to go after that.

What will the 'user space policy' bit do what the kernel cannot?

If you mean the user has to configure something manually - that wont 
really happen in practice. We are happy if they know where to put 
those USB sticks in ;-)

	Ingo
