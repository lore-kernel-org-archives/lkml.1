Return-Path: <linux-kernel-owner+w=401wt.eu-S1751567AbZL1UFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbZL1UFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZL1UFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:05:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55234 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZL1UFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:05:49 -0500
Date: Sun, 27 Dec 2009 12:09:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
Message-ID: <20091227110947.GA1398@ucw.cz>
References: <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdomain> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain> <20091223170832.GH20539@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223170832.GH20539@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > This might suggest that Mark's floppy controller doesn't like
> > > deep C? Mark, did you try booting with processor.max_cstate=1
> > > and HPET enabled?
> > 
> > We have indeed had historical issues with floppy and sleep states before. 
> 
> I removed that code when moving to 64bit (floppy driver disabling C1),
> but perhaps we need some variant of it again (but it's the first such
> report in many years). Although it would be sad to have it again on all 
> systems.

C1 is hlt. Are you sure? I could see how C3 could cause problems (DMA
 latency), but...

Can mark simply try with idle=poll?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
