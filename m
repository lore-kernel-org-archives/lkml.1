Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYDHUTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYDHUTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYDHUTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:19:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52537 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbYDHUT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:19:29 -0400
Message-ID: <47FBD34A.6080508@garzik.org>
Date: Tue, 08 Apr 2008 16:19:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Matthew Wilcox <matthew@wil.cx>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
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
Subject: Re: [regression] e1000e broke e1000
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <20080408193245.GG11962@parisc-linux.org> <20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org> <20080408200652.GC28148@elte.hu>
In-Reply-To: <20080408200652.GC28148@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i repeat, it took me more than an hour to figure out why there's no 
> networking on my laptop. Guess how much it takes for a plain user to 
> figure out the same problem.

A plain user would have obtained a working distro kernel, putting this 
rare problem purely in the laps of people with highly unusual kernel 
configs...

But as noted in the announcement, the fix is for this is to continue in 
the next step in the transition, then you only have one driver claiming 
those IDs, for any given config.  No need for further Kconfig tweakage.

	Jeff


