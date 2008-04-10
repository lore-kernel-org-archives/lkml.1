Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYDJW1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYDJW1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYDJW10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:27:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50551 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYDJW1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:27:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: x86 git tree broken
Date: Fri, 11 Apr 2008 00:27:05 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>
References: <200804102159.14563.rjw@sisk.pl> <20080410205106.GB15440@elte.hu>
In-Reply-To: <20080410205106.GB15440@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804110027.06078.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 10 of April 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Second, if I try to suspend the box to RAM, it enters a state it 
> > cannot leave until power is physically cut from it (using the power 
> > button to power off / power on the box doesn't help).
> 
> i used your config on an AMD system here and s2ram works just fine, both 
> using CONFIG_PM_TEST_SUSPEND=y bootup suspend self-test [which x86.git 
> QA uses all the time], and using a manual pm-suspend command at the 
> console.
> 
> you can also try your luck and remove the last 20% of x86.git [which is 
> always the newest stuff], by picking a commit 200 patches down the line, 
> via:
> 
>  git-rev-list x86/base..x86/latest | head -200 | tail -1
> 
> and testing that. If that tree works, it's the last 200 commits that 
> break stuff.

Yes, I'll probably do that, but don't have that much time today.

> exactly what kind of system are you using?

It's an Athlon 64 X2 on an ULi-based AsRock motherboard with Radeon X300SE
(PCIe).

> If you revert the trampoline changes, does it get any better - but i guess
> it might be better to do a bisection.

I'll try to figure out what is the last good commit.

Thanks,
Rafael
