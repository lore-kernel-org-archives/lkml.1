Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYLWA25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYLWA25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYLWA2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:28:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56532 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYLWA2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:28:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TSC not updating after resume: Bug or Feature?
Date: Tue, 23 Dec 2008 01:28:28 +0100
User-Agent: KMail/1.9.9
Cc: Fabio Comolli <fabio.comolli@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <b637ec0b0812221429m441b9493q97a7ccb82dfc0334@mail.gmail.com> <alpine.LFD.2.00.0812222332400.3723@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812222332400.3723@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812230128.29586.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 22 of December 2008, Thomas Gleixner wrote:
> Fabio,
> 
> On Mon, 22 Dec 2008, Fabio Comolli wrote:
> 
> > OK, it seems that you got it.
> > 
> > The system survived two hibernation / resume cycles without triggering
> > the warning and, probably the most important part, the dmesg does not
> > have any "jumps" before the "Force enable HPET on resume" line as
> > before:
> > 
> > [  275.647704] PM: Creating hibernation image:
> > [  275.648005] PM: Need to copy 177844 pages
> > [  275.648005] Intel machine check architecture supported.
> > [  275.648005] Intel machine check reporting enabled on CPU#0.
> > [  275.648005] Force enabled HPET at resume
> > [  275.648005] ACPI: Waking up from system sleep state S4
> > [  275.669038] ACPI: EC: non-query interrupt received, switching to
> > interrupt mode
> > [  275.740697] pcieport-driver 0000:00:01.0: setting latency timer to 64
> > [  275.740781] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> > [  275.740786] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
> > 
> > ...and so on.
> > 
> > As i mentioned in the bug report, to be sure that the bug doesn't
> > trigger I have to wait at least on day and > 10 hibernation / resumee
> > cycles.
> 
> Sure.
>  
> > But with your first patch the bug triggered at the second cycle, so
> > I'm optimist :-)
> > 
> > I'll keep you informed. Many thanks in advance,
> 
> Many thanks to you for following up on this.

Well, thanks a lot to you both for debugging this and finding a fix.

Rafael
