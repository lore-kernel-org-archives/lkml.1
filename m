Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbYFMLvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbYFMLvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYFMLvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:51:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43915 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYFMLvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:51:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/6] AMD C1E aware idle support
Date: Fri, 13 Jun 2008 13:52:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080610171639.551369443@linutronix.de> <20080612123212.GA8085@elte.hu> <200806131118.31160.rjw@sisk.pl>
In-Reply-To: <200806131118.31160.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131352.41671.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 of June 2008, Rafael J. Wysocki wrote:
> On Thursday, 12 of June 2008, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.gz
> > > > or
> > > > http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.bz2
> > > 
> > > I guess the x86-next-apic-timer-fixes.patch is a combination of all 
> > > patches in this series.  Is that correct?
> > 
> > you can also try out those patches via running tip/master. (the patches 
> > from Thomas are queued up in the tip/x86/cpu topic branch)
> 
> I tested this one eventually. :-)
> 
> It seems to work quite well on the nx6325 that caused us so many headaches in
> the past, even suspend to RAM doesn't break which is a good sign.

Well, unfortunately, an attempt to suspend to RAM after a successful
hibernation-restore cycle finally hanged the machine. :-(

Thanks,
Rafael
