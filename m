Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZEBBK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZEBBK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 21:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZEBBKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 21:10:12 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48687 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZEBBKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 21:10:11 -0400
Date: Sat, 2 May 2009 10:04:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org, zippel@linux-m68k.org,
       magnus.damm@gmail.com, wli@holomorphy.com, rth@twiddle.net
Subject: Re: [RESEND][PATCH 2/2] Convert sh to use arch_getoffset() infrastructure.
Message-ID: <20090502010446.GB11832@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
	rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
	takata@linux-m32r.org, geert@linux-m68k.org, zippel@linux-m68k.org,
	magnus.damm@gmail.com, wli@holomorphy.com, rth@twiddle.net
References: <1239759163.6064.25.camel@localhost> <1239759251.6064.27.camel@localhost> <1239759393.6064.30.camel@localhost> <20090501131006.fa631417.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501131006.fa631417.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:10:06PM -0700, Andrew Morton wrote:
> On Tue, 14 Apr 2009 18:36:33 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > This patch converts sh to use GENERIC_TIME via the arch_getoffset()
> > infrastructure 
> > 
> > I have tried cross-compiling this for sh3 and sh4. Also little has
> > changed since my last submission where it was acked. So I've taken my
> > best swing at converting this, but I'm not 100% confident I got it
> > right. Any assistance from arch maintainers or testers would be great.
> 
> arch/sh/kernel/timers/timer-cmt.c has just vanished from linux-next and
> I didn't find it popping up anywhere else, so I simply dropped that hunk
> from the patch.
> 
We have been doing a bit of timer chainsawing lately trying to get the
last stragglers moved over to clockevents/clocksource code to enable us
to kill the old bits and use GENERIC_TIME always. So, it's more bitrot by
design ;-)
