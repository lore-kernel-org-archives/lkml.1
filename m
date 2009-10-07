Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZJGLQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZJGLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758889AbZJGLQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:16:56 -0400
Received: from www.tglx.de ([62.245.132.106]:43082 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbZJGLQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:16:56 -0400
Date: Wed, 7 Oct 2009 13:15:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Noonan <steven@uplinklabs.net>
cc: Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BISECTED] "conservative" cpufreq governor broken
In-Reply-To: <f488382f0910070403s4659869tf3729778ec0082a1@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0910071306300.9428@localhost.localdomain>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>  <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>  <1254901778.30157.62.camel@eenurkka-desktop>  <f488382f0910070105g19cbf75ci8034f2917b7e5606@mail.gmail.com> 
 <1254903263.30157.69.camel@eenurkka-desktop>  <f488382f0910070124v6f1e1539gbeb7765ab6f32231@mail.gmail.com>  <1254905013.30157.75.camel@eenurkka-desktop>  <f488382f0910070152y1c09602by444fd9466912bbb5@mail.gmail.com>  <1254907901.30157.93.camel@eenurkka-desktop>
  <alpine.LFD.2.00.0910071237040.9428@localhost.localdomain> <f488382f0910070403s4659869tf3729778ec0082a1@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Steven Noonan wrote:
> > Well, probably because the machine never switched to NOHZ :)
> >
> >> > Also, this fix should probably be passed on to Greg K. H. (so it goes
> >> > in 2.6.31-stable) as well as Ingo Molnar (so it goes into -tip, and
> >> > hopefully to Linus for 2.6.32). Both CC'd.
> >
> > Don't worry, it'll go the right way. No need to cc the world and some
> > more :)
> >
> 
> Sorry if it's not kosher. I was told that when dealing with a
> bisection you should CC:
> 1. those involved with a bisected patch (the Signed-off-by people),
> 2. those responsible for the affected subsystem (doing an author check
> via script[1]),
> 3. and those to whom a fix should be passed on to.
> 
> Any tips so I don't bug the wrong people (or too many people) in the future?

No worry. It's just Linus and Greg who got some extra mail into their
inbox. The flow is that the patch is picked up by the maintainer and
pushed into his git tree which is then offered to Linus for pulling it
into mainline. We add a Cc: stable@kernel.org tag to the commit, which
triggers a notifier to the stable kernel team when the patch hits
Linus tree.

Thanks,

	tglx
