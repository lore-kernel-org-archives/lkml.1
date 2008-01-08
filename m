Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYAHSkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYAHSkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYAHSkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:40:31 -0500
Received: from main.gmane.org ([80.91.229.2]:41797 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYAHSkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:40:31 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 18:40:14 +0000 (UTC)
Message-ID: <slrnfo7gse.fne.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi> <20080108182904.GB16462@skl-net.de>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-08, Andre Noll <maan@systemlinux.org> wrote:
> It's not a workaround. The ext3 maintainers argue that every file
> system should be checked from time to time. Therefore it's the
> default. You do not agree with them, so change the default and be
> happy. 

The thing is, I agree with them (although the default intervals could
be a bit longer), but it gets confused and thinks it's been years since
last check, when it hasn't. I have my doubts that Theodore Tso's reply
is the problem here, because I didn't use to have this problem; it 
appeared relatively recently. But maybe old versions of e2fsck were
smarter...

> Use the time you are currently using for whining on mailing lists.

That's doable on time you'd spend idling anyway. There are only so
many hours of the day that you can do work that demands considerable
thinking.

> Then write a set of udev rules for your SCSI devices. It's easy.

It isn't. There's no simple pre-existing setting to edit. And besides,
it's the wrong approach from the POV of clean consistent design. It's
the kludged worse-is-better approach that results in unusable 
clusterfucks.

> If you're not willing to compile, you'll have to use what other
> people provide. It's your choice, but at least there _is_ a choice.

I'd compile, if the thing to be compiled weren't made uncompilable.
I'd use pre-compiled shit, if it wasn't shit.

> I tend to disagree. It's not hard at all to configure a kernel if
> you know the hardware. It's even easier if you already have a working
> config for some kernel version. Just use "make oldconfig" to upgrade
>=66rom one version to the next as already suggested by others and me.

It didn't use to be hard for 1.2 or so, but it's been constantly getting
worse, along with all the bloat. 

>> And then there's the problem that the "good" driver for my SATA disk
>> may not be there anymore in the latest kernels, and so on.
>
> That is clearly a regression and I'm sure Jeff and other maintainers
> of the driver would be interested in details on this matter.

I don't know the details; all I know is that I've heard that the old
SATA drivers that appear as /dev/hd$PREDICTABLE are being obsoleted in
favour of those that appear as /dev/sd$RANDOM along with all the USB
devices and whatnot.

-- 
Tuomo

