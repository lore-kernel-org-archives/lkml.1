Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYC3Poz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYC3Poz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 11:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYC3Pop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 11:44:45 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:35285 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYC3Poo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 11:44:44 -0400
Date: Sun, 30 Mar 2008 19:44:41 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080330154441.GA24201@jurassic.park.msu.ru>
References: <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <20080326232922.GA15784@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261638350.2775@woody.linux-foundation.org> <alpine.LFD.1.00.0803271004380.2775@woody.linux-foundation.org> <20080327221851.GA9675@jurassic.park.msu.ru> <20080328192402.GA6233@us.ibm.com> <20080328204616.GB6233@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328204616.GB6233@us.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:46:16PM -0700, Gary Hade wrote:
> > Ivan, After adding a resource_alignment() prototype to
>                  < snip >
> > Will now try on one of our servers that I am the most concerned
> > about.
> 
> Just tried it on an IBM x3850.  No obvious problems or unexpected
> messages spotted during/following boot or during/following hotplug
> of PCI-X and PCIe cards.

Thanks for testing. I've also tested an updated patch (with BUG_ON()
replaced by printk and a resource_alignment() prototype) on alpha
and x86 - works as expected.

Ivan.
