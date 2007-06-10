Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbXFJObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbXFJObU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 10:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXFJObI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 10:31:08 -0400
Received: from www.osadl.org ([213.239.205.134]:60096 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752293AbXFJObH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 10:31:07 -0400
Subject: Re: [patch-mm 07/23] Tick management: spread timer interrupt
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20070610141617.GA15173@rhlx01.hs-esslingen.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <20070610092446.625214085@inhelltoy.tec.linutronix.de>
	 <20070610141617.GA15173@rhlx01.hs-esslingen.de>
Content-Type: text/plain
Date: Sun, 10 Jun 2007 16:31:03 +0200
Message-Id: <1181485863.384.15.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-10 at 16:16 +0200, Andreas Mohr wrote:
> Hi,
> 
> On Sun, Jun 10, 2007 at 09:44:05AM -0000, Thomas Gleixner wrote:
> > From: john stultz <johnstul@us.ibm.com>
> > 
> > After discussing w/ Thomas over IRC, it seems the issue is the sched
> > tick fires on every cpu at the same time, causing extra lock contention.
> 
> Hmm, the cpu-specific offset calculation isn't too expensive, hopefully?
> (div/mul in patch, maybe this could be done differently)

That's one time during setup, no hot path.

	tglx


