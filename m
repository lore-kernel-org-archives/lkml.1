Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYI3Do0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYI3Do0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYI3DoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:44:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:51951 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbYI3DoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:44:17 -0400
Subject: Re: [GIT pull] timer fixes for .27
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080929224440.GG6697@linux.vnet.ibm.com>
References: <alpine.LFD.2.00.0809292255490.17289@localhost.localdomain>
	 <20080929224440.GG6697@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 13:41:56 +1000
Message-Id: <1222746116.9006.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-29 at 15:44 -0700, Paul E. McKenney wrote:
> > Please pull the latest timers-fixes-for-linus git tree from:
> > 
> >
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> timers-fixes-for-linus
> > 
> > The patches fix hard to trigger bugs in the CPU offline code of
> > hrtimers which were noticed by Paul McKenney recently. In the worst
> > case they can leave migrated hrtimers in a stale state.
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Ah, so we found and fixed these ?

Linus, those bugs are actually a regression from when we didn't use the
new timer code (which isn't that long ago). It would be nice to have the
fixes in .27 (and thus in the various distros that will derive from it)
but I would understand if the size of the patch made you choke that late
in the -rc cycle... In which case we'll be in for more backports :-)

Cheers,
Ben.


