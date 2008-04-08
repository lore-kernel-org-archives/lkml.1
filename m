Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYDHSQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYDHSQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 14:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYDHSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 14:15:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbYDHSP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 14:15:58 -0400
Date: Tue, 8 Apr 2008 20:15:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ANNOUNCE] e1000 to e1000e migration of PCI Express devices
Message-ID: <20080408181510.GA16593@elte.hu>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FB9ABB.9080403@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> > The following .config results in a non-working e1000 driver in a 
> > bzImage:
> > 
> >  CONFIG_E1000=y
> >  CONFIG_E1000_NAPI=y
> >  CONFIG_E1000_DISABLE_PACKET_SPLIT=y
> >  CONFIG_E1000E=m
> >  CONFIG_E1000E_ENABLED=y
> > 
> > the interface just doesnt come up.
> > 
> > This makes it work:
> > 
> >  CONFIG_E1000=y
> >  CONFIG_E1000_NAPI=y
> >  CONFIG_E1000_DISABLE_PACKET_SPLIT=y
> >  # CONFIG_E1000E is not set
> >  # CONFIG_E1000E_ENABLED is not set
> > 
> > please fix such interactions and make the transition as smooth and as 
> > compatible as possible.
> 
> This is really a vague report. Maybe you need to adjust your network 
> setup to explicitly load the correct driver at boot? The adapter works 
> correct here and I have a stock T60 here as well, just as you.

try the config combination i gave you [that's all that is needed - plug 
the above lines into your .config of choice] - does that work fine for 
you?

	Ingo
