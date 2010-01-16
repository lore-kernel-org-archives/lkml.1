Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729Ab0APWGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0APWGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398Ab0APWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:06:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001Ab0APWGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:06:36 -0500
Date: Sat, 16 Jan 2010 14:04:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: m.s.tsirkin@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.ker>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
In-Reply-To: <201001162257.16277.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1001161402400.13231@localhost.localdomain>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <20100116174821.GA18306@redhat.com> <201001162257.16277.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Jan 2010, Rafael J. Wysocki wrote:
>
> > Immediately upon startup, screen is flickering (becomes
> > lighter and darker again). The problem occurs with kernels
> > 2.6.33-rc1 to 2.6.33-rc4, but not with kernel 2.6.32 and below.
> 
> We've already had several reports like this already.
> 
> Care to review the bugs linked to http://bugzilla.kernel.org/show_bug.cgi?id=14885
> and check if none of them matches the problem you describe?

I suspect that should be fixed by commit 33814341f22 ("drm/i915: disable 
LVDS downclock by default") that got merged today.

So try current -git. 

		Linus
