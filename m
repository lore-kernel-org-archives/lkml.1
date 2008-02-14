Return-Path: <linux-kernel-owner+w=401wt.eu-S1765444AbYBNVig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765444AbYBNVig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbYBNVi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:38:26 -0500
Received: from www.tglx.de ([62.245.132.106]:44222 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbYBNVi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:38:26 -0500
Date: Thu, 14 Feb 2008 22:37:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>
Subject: Re: [stable] [GIT pull] hrtimer fixes
In-Reply-To: <20080214212643.GA18521@kroah.com>
Message-ID: <alpine.LFD.1.00.0802142236440.12988@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0802142120200.12988@apollo.tec.linutronix.de> <20080214212643.GA18521@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Greg KH wrote:

> On Thu, Feb 14, 2008 at 10:19:23PM +0100, Thomas Gleixner wrote:
> > Linus,
> > 
> > please pull hrtimer fixes from:
> > 
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master
> > 
> > The first patch fixes an overflow problem, which is caused by missing
> > checks in the relative to absolute time conversion in the futex
> > code. It got caught by the WARN_ON() in clockevents_program_event().
> > 
> > The second patch prevents a false positive of the same WARN_ON().
> > 
> > Fixes are confirmed to solve http://lkml.org/lkml/2008/2/10/137
> 
> Are one of these needed in the stable tree?

Yes, both are for stable as well. The report was against 2.6.24 stable
 
> If so, you can just add a:
> 	Cc: stable <stable@kernel.org>
> to the signed-off-by area, and we (the stable tree developers) will get
> an automated email when it goes into Linus's tree, with the git
> changelog entry.

Will do next time.

Thanks,

	tglx
