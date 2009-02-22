Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZBVOYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZBVOYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 09:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZBVOYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 09:24:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58786 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZBVOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 09:24:05 -0500
Date: Sun, 22 Feb 2009 15:23:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090222142351.GG1586@ucw.cz>
References: <20090213155507.GA2838@Krystal> <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain> <20090213173352.GB4684@Krystal> <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain> <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain> <20090213185411.GB7124@Krystal> <20090213193619.GH6854@linux.vnet.ibm.com> <8bd0f97a0902132107r3651ce4rc5bc4e027268e2aa@mail.gmail.com> <20090214052030.GB7194@linux.vnet.ibm.com> <8bd0f97a0902132146t2badab79ue76e0a43d74c95ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0902132146t2badab79ue76e0a43d74c95ca@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> > If Blackfin handles hotplug CPU, that may
> > need attention as well, since tasks affinitied to the CPU being removed
> > can end up with their affinity set to all CPUs.  And there are probably
> > other issues.
> 
> no, we dont support hotplugging of CPUs.  there is no hardware support
> for it, so i think the only thing you'd gain is perhaps power savings
> ?  not sure it would even work in our case though as the hardware does
> not support restarting or shutdown of one core ... they both have to
> restart/shutdown.  putting one core into a constant idle loop would
> save power, but that can already be accomplished by reducing the apps
> that go onto a specific core.

Well, cpu hotplug is needed for suspend and hibernation...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
