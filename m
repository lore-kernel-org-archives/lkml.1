Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYCPWDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYCPWDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYCPWDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:03:03 -0400
Received: from khc.piap.pl ([195.187.100.11]:49332 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYCPWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:03:01 -0400
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net>
	<200803151533.10797.phillips@phunq.net>
	<20080315232221.GA24227@1wt.eu>
	<200803152033.08788.phillips@phunq.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 16 Mar 2008 23:02:58 +0100
In-Reply-To: <200803152033.08788.phillips@phunq.net> (Daniel Phillips's message of "Sat\, 15 Mar 2008 19\:33\:07 -0800")
Message-ID: <m3skyq8gz1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> writes:

> Anecdote time.  Remember there used to be "brand name" floppy disks and
> generic floppy disks, and the brand name ones cost a lot more because
> they were supposedly safer?  Well, big secret, studies were done and
> the no-name disks came out better.  Why?  Because selling at commodity
> prices the generic makers could not afford returns.  So they made them
> well.

I don't think so. I remember we had much more problems with noname
disks. And yes, certain brands had been problematic too, but most
(such as Fuji and 3M, and others) were fine.

> It is like that with PCs.  Supposedly you get a lot more reliability
> when you spend more money and buy all high end near-custom gear.  In
> fact, the cheap stuff just keeps on chugging, because those guys can't
> afford to have it break.

The real life can't agree with this at all. The servers keep working
for years and the cheap stuff quit fast (if initially working, which
is not always the case).

> The worst bug I've seen in a server this year?  A buggy bios in a Dell
> server that would issue a keyboard error and sit and wait for somebody
> to press F1 when there was no keyboard attached.

Most BIOS (all I've seen in this Millennium) have an option to disable
that.

On a server board you can usually have a remote console, how could
that work otherwise?

> That is embedded
> software for you.

Server != embedded.

> Yes.  Dual power supplies are highly recommended for this
> application.

:-)
So which user groups are you aiming at exactly?

> Right.  What we are talking about is filling in a missing level in the
> cache hierarchy, something like:
>
>    L1 .3 ns
>    L2 3 ns
>    L3 30 ns
>    Ramdisk 2 us
>    Flash 20 us
>    Disk 3 ms

We already have RAM between L3 and Flash.
The problem is flushing L1 to disk/flash takes time.
-- 
Krzysztof Halasa
