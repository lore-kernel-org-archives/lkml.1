Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXCGUv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXCGUv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992562AbXCGUv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:51:56 -0500
Received: from 1wt.eu ([62.212.114.60]:1058 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928AbXCGUvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:51:54 -0500
Date: Wed, 7 Mar 2007 21:48:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] the scheduled removal of OBSOLETE_OSS options
Message-ID: <20070307204836.GA22200@1wt.eu>
References: <20070305014956.GE3441@stusta.de> <45EDA8EE.1060308@tmr.com> <20070306175504.GW3441@stusta.de> <20070307062157.GJ943@1wt.eu> <20070307195601.GZ3441@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307195601.GZ3441@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian !

On Wed, Mar 07, 2007 at 08:56:02PM +0100, Adrian Bunk wrote:
(...)
> > Real problem is that we can expect several "sound does not work anymore"
> > because people doing "make oldconfig" will get no warning at all about
> > the removed options. Remember people complaining about keyboard not working ?
> 
> There already were two kernel releases where people had to say
> explicitely "yes" to "Obsolete OSS drivers" with a quite clear help text
> for getting these OSS drivers.

To be fair, I did not notice it, but I think that people who will miss it
will have skipped 2 versions, in which case they can reasonably expect
enough changes to be very careful when updating their config.

> And did you complain when all the SATA options were renamed in 2.6.19
> without any warnings in previous kernels and far more user-visible 
> effects than some obsolete OSS drivers (and no driver for your hard 
> disk even prevents booting)?

No, because I have no SATA disk ;-)

> Or about the mess with the mes with the netfilter options when upgrading 
> from 2.6.19 to 2.6.20?

Yes I've noticed this one, and at least it was clearly visible !

> If you didn't, this is the wrong patch to start complaining about...

Don't get me wrong, I'm not complaining. I just realized from previous
post that options disappearing produce no warning on make oldconfig, and
that it is easy to get trapped, even though there's nothing harmful.

> > Perhaps the real problem is more Kconfig than OSS, but it would be fine if
> > we found a solution to enumerate the list of options which have been removed
> > when they do their make oldconfig.
> 
> Printing won't help - there are two many options (some even not user 
> visible) that disappear with each kernel release.

Sometimes I do a diff between old and new config, and I do not notice
that many changes. So maybe a simple report at the end saying "The
following options have been removed" may catch people's attention
when it lists something which looks like a driver they know they use.

Anyway, I don't have time to propose something in this area, and I
know that talking is cheap, showing the code is another matter.

Cheers,
Willy

