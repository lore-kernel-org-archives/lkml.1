Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbYDKL1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbYDKL1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759289AbYDKL1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:27:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYDKL1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:27:31 -0400
Date: Fri, 11 Apr 2008 13:26:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
Message-ID: <20080411112653.GC9205@elte.hu>
References: <47FBCE00.2020309@garzik.org> <20080408200652.GC28148@elte.hu> <47FBD34A.6080508@garzik.org> <20080408203314.GA28952@elte.hu> <47FBDBE9.9040700@garzik.org> <20080409193850.GA11763@elte.hu> <47FD2325.2030705@intel.com> <47FE5C89.5060209@intel.com> <20080410192714.GA14055@elte.hu> <47FE8566.5040809@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FE8566.5040809@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> Again - this has happened before, I remember many of my boxes not 
> booting because SATA Kconfig options changed and all my boxes failed 
> to move the proper Kconfig symbols over when I ran `make oldconfig` 
> myself. Somewhere around 2.6.20 or so.

that's an insane argument ... because we messed up in the past and have 
hurt users (and probably lost users) you feel like it gives you a free 
card to mess up again???

The IDE -> SATA migration, while i like the new SATA code and find it 
excellent and well-maintained (many kudos for that to Tejun, Jeff, Alan 
& co), caused a lot of trouble for users in one specific area, for no 
good reasons other than stupid personality conflicts: /dev/hda worked 
just as well as /dev/sda, the _name_ of the device should never have 
been changed.

So if you use _that_ aspect of the (otherwise cool) SATA/PATA code as a 
blueprint for the e1000 -> e1000e migration then you are on the worst 
possible track in terms of picking a role model ;-) It's as if you 
adored Sylvester Stallone for his vivid mimics, Jean-Claude Van Damne 
for his excellent acting skills and Paris Hilton for her brillant brain.

really, just because you do exceedingly good things to Linux does not 
give you a free card to do something bad to Linux in exchange. The two 
do not cancel out each other - because the bad things _add up_ and drive 
away users, irreversibly. To you e1000 is the center of the universe so 
you feel the price is worth paying. For others it is not. We want the 
good things from you and we'll say no thanks to the bad ideas. Kernel 
developers, especially old-timers, regularly forget about that.

	Ingo
