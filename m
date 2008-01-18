Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbYARNvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbYARNvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbYARNvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:51:16 -0500
Received: from waste.org ([66.93.16.53]:35056 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbYARNvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:51:15 -0500
Subject: Re: [PATCH] x86: fix
	unconditional	arch/x86/kernel/pcspeaker.c?compiling
From: Matt Mackall <mpm@selenic.com>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4790A385.800@free-electrons.com>
References: <200801171643.49301.michael-lists@free-electrons.com>
	 <478F8AEC.1080209@free-electrons.com>
	 <1200590031.5332.19.camel@cinder.waste.org>
	 <200801172315.29976.michael-lists@free-electrons.com>
	 <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com>
	 <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu>
	 <4790A385.800@free-electrons.com>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 07:50:14 -0600
Message-Id: <1200664214.4001.24.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 14:03 +0100, Michael Opdenacker wrote:
> However, wouldn't the Makefile look nicer if we introduced a
> CONFIG_PCSPEAKER setting as in the mips platform? We would just have:
> 
> obj-$(CONFIG_PCSPEAKER)		+= pcspeaker.o

Yes, that would be cleaner. Not worth it for just x86, but there are
about 6 other arches that use CONFIG_INPUT_PCSPKR. Do that in one patch
on top of this one and send it to Andrew (who will pull the above into
his tree from Ingo shortly).

> I can propose a corresponding patch, and I'd suggest to make
> CONFIG_PCSPEAKER depend on CONFIG_EMBEDDED.

No, don't. It's fine the way it is. If INPUT_PCSPKR isn't set, we don't
support the speaker, end of story.

Also, bear in mind that there is a fair amount of lower-hanging fruit
than this, so bouncing a bunch of patches back and forth to make this
perfect is not the best use of people's time.

-- 
Mathematics is the supreme nostalgia of our time.

