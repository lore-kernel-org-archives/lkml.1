Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYGaTOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYGaTOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYGaTNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:13:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758106AbYGaTNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:13:48 -0400
Date: Thu, 31 Jul 2008 12:10:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
In-Reply-To: <20080731145023.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Dmitry Torokhov wrote:
> > 
> > Well, we're not supposed to break user space that we used to work with, even
> > if it is known to be buggy.
> 
> No, I am sorry. We are not supposed to break userspace ABI, but that
> is it. Can you vouch that 2.6.25 did not break a single userspace
> program out there?

Dmitry - irrelevant. If we know of breakage, then that is a FACT, and it's 
a regression, and it needs to be fixed.

Trying to say "there might be _other_ breakage that we don't even know of" 
does not change the situation ONE LITTLE BIT!

Don't you see how stupid that approach is? You're basically trying to make 
excuses for known breakage by saying that there might be _other_ breakage 
that we don't know about? Why the _hell_ do you think that is an excuse at 
all?

> >  Many people use the older user space on their
> > test systems which are not practical to upgrade.
> 
> I don't understand this - it is expected that everyone jumps and
> upgrades their kernels with ease but updating broken userspace
> bits is super-hard...

You're missing the point.

People are supposed to be able to upgrade things _independently_. It's not 
about "you're supposed to be able to upgrade the kernel, but not upgrade 
user space". It's about "you shouldn't evemn have to _worry_ about it.

> > IOW, if the change responsible for this makes it to the mainline kernel, it
> > will be considered as a regression.
> 
> Like I said, I don't agree.

Sorry, but you're simply wrong.

If somebody has the commit that broke user space, that commit will be 
_reverted_ unless it's fixed. It's that simple. The rules are: we don't 
knowingly break user space. 

			Linus

