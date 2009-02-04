Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZBDKL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZBDKL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZBDKLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:11:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48874 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZBDKLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:11:49 -0500
Date: Wed, 4 Feb 2009 10:07:05 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore standard config registers of all devices early)
Message-ID: <20090204100704.GA19498@flint.arm.linux.org.uk>
References: <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain> <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain> <20090203191334.GA2797@elte.hu> <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain> <20090203195304.GA31049@elte.hu> <alpine.LFD.2.00.0902031209280.3247@localhost.localdomain> <20090203205727.GA4460@elte.hu> <20090203210442.GA27804@elte.hu> <alpine.LFD.2.00.0902032209060.22800@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902032209060.22800@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 10:12:04PM +0100, Thomas Gleixner wrote:
> On Tue, 3 Feb 2009, Ingo Molnar wrote:
> > So i'd still like your tentative Signed-off-by for your patch - it's i think 
> > not v2.6.29 material but if it stays problem free in testing we can try it 
> > in v2.6.30. If it causes problem it will be clearly bisectable and clearly 
> > revertable.
> > 
> > Maybe we could split it in two: and for MSI we could introduce a 'simpler 
> > and faster' edge flow as well - and keep the legacy handler untouched. That 
> > way it's low-risk in its entirety. (and avoids the MSI ->mask complication 
> > as well.)
> 
> Yes, seperating out the MSI handler into it's own flow control is the
> right way to go. We had trouble with real edge hardware and IIRC most
> of the problems originated from ARM. rmk ??

No idea, too long ago.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
