Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYD2Hi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYD2Hi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYD2Hit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:38:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbYD2Hit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:38:49 -0400
Date: Tue, 29 Apr 2008 00:37:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Bernhard Walle <bwalle@suse.de>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Solid freezes with 2.6.25
Message-Id: <20080429003747.6237a0ed.akpm@linux-foundation.org>
In-Reply-To: <20080429072423.GB7902@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
	<20080429072423.GB7902@boogie.lpds.sztaki.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 09:24:23 +0200 Gabor Gombas <gombasg@sztaki.hu> wrote:

> On Mon, Apr 28, 2008 at 04:29:35PM +0200, Gabor Gombas wrote:
> 
> > More info about the machine is attached. I've also seen similar hangs with
> > 2.6.25-rc6 on an nforce4/Athlon64 box but I'm reluctant to re-test there
> > because RAID rebuild takes too long.
> 
> Well, I accidentally booted 2.6.25 on that machine and it locked within
> 10 minutes. Machine details follow. On this machine however there are no
> complaints about lost rtc interrupts.
> 
> More observations: on the Intel Core2 Duo box 2.6.25 feels much more
> sluggish than 2.6.24.x. Under some I/O load I feel if I was typing
> through a slow remote network link instead of sitting in front of the
> console. Keys sometimes start to auto-repeat in gnome terminal even if I
> just press them once. The AMD box does not feel so sluggish, but sound
> playback sometimes becomes jerky a couple of seconds before the freeze.

I suspect you have two separate regressions here.
