Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbYDKLbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbYDKLbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbYDKLa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:30:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759099AbYDKLaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:30:55 -0400
Date: Fri, 11 Apr 2008 13:30:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Matthew Wilcox <matthew@wil.cx>,
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
Message-ID: <20080411113018.GD9205@elte.hu>
References: <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <20080408193245.GG11962@parisc-linux.org> <20080408195123.GA28148@elte.hu> <47FBCE00.2020309@garzik.org> <20080408200652.GC28148@elte.hu> <47FBD620.1080508@intel.com> <20080409191256.GB9276@elte.hu> <47FD19F5.9020509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FD19F5.9020509@garzik.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

>> So i'm not sure why you are arguing about all this. Please just fix 
>> this bug, simple as that.
>
> I haven't said NAK, but I think the suggested fix is a waste of time 
> because
>
> 1) it breaks (by disallowing) a valid setup based on one report
>
> 2) it only happens to experienced kernel hackers with weird configs
>
> 3) the suggested fix binds together more tightly two drivers we are 
> trying to keep separate
>
> 4) it is a temporary situation that will go away in 2.6.26 anyway

well, your 2.6.26 plans, if i understand them correctly, is to move 
currently working PCI IDs from e1000 to e1000e, like you attempted to d 
it in v2.6.24, which Linus reverted - correct? I.e. e1000 simply wont 
support eth0 on my T60 from 2.6.26 on? That is still an incredibly 
stupid plan, and no amount of announcement on lkml will make it any less 
stupid.

... which pretty much pulls the rug from under your argument, no?

	Ingo
