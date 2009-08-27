Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZH0VvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZH0VvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZH0VvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:51:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37594 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbZH0VvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:51:05 -0400
Date: Thu, 27 Aug 2009 23:50:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chris Adams <cmadams@hiwaay.net>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090827215056.GA1461@ucw.cz>
References: <dddWc-83W-51@gated-at.bofh.it> <ddefx-5R-37@gated-at.bofh.it> <ddep7-bI-7@gated-at.bofh.it> <ddeyR-iy-11@gated-at.bofh.it> <ddeyR-iy-9@gated-at.bofh.it> <ddeIu-n9-9@gated-at.bofh.it> <ddeSb-th-29@gated-at.bofh.it> <ddoRI-11a-39@gated-at.bofh.it> <ddpkB-1jQ-1@gated-at.bofh.it> <20090826134045.GA1516467@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826134045.GA1516467@hiwaay.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The other thing about this thread is that the only RAID implementation
> that is being discussed here is the MD RAID stack.  There are a lot of
> RAID implementations that have the same issues:
> 
> - motherboard (aka "fake") RAID - In Linux this is typically mapped with
>   device mapper via dmraid; AFAIK there is not a tool to scrub (or even
>   monitor the status of and notify on failure) a Linux DM RAID setup.
> 
> - hardware RAID cards without battery backup - these have the exact same
>   issues because they cannot guarantee all writes complete, nor can they
>   keep track of incomplete writes across power failures
> 
> - hardware RAID cards _with_ battery backup but that don't periodically
>   test the battery and have a way to notify you of battery failure while
>   Linux is running
> 
> The issues being raised here are not specific to extX, MD RAID, or Linux
> at all; they are problems with non-"enterprise-class" RAID setups.
> There's a reason enterprise-class RAID costs a lot more money than the
> card you can pick up at Fry's.
> 
> There's no reason to document the design issues of general RAID
> implementations in the Linux kernel.

Even when we carry one of those misdesigned implementations in-tree?
(Note that fixed implementations do exist -- AIX? -- just add journal).

'I wont't tell you that this pony bites, because many ponies do bite'?

WTF? I thought we had higher moral standard than this.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
