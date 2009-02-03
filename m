Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZBCVNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZBCVNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZBCVND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:13:03 -0500
Received: from www.tglx.de ([62.245.132.106]:47600 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZBCVNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:13:01 -0500
Date: Tue, 3 Feb 2009 22:12:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <20090203210442.GA27804@elte.hu>
Message-ID: <alpine.LFD.2.00.0902032209060.22800@localhost.localdomain>
References: <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain> <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain>
 <20090203191334.GA2797@elte.hu> <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain> <20090203195304.GA31049@elte.hu> <alpine.LFD.2.00.0902031209280.3247@localhost.localdomain> <20090203205727.GA4460@elte.hu> <20090203210442.GA27804@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Ingo Molnar wrote:
> So i'd still like your tentative Signed-off-by for your patch - it's i think 
> not v2.6.29 material but if it stays problem free in testing we can try it 
> in v2.6.30. If it causes problem it will be clearly bisectable and clearly 
> revertable.
> 
> Maybe we could split it in two: and for MSI we could introduce a 'simpler 
> and faster' edge flow as well - and keep the legacy handler untouched. That 
> way it's low-risk in its entirety. (and avoids the MSI ->mask complication 
> as well.)

Yes, seperating out the MSI handler into it's own flow control is the
right way to go. We had trouble with real edge hardware and IIRC most
of the problems originated from ARM. rmk ??

Thanks,

	tglx
