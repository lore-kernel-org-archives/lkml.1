Return-Path: <linux-kernel-owner+w=401wt.eu-S1764924AbZEAUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764924AbZEAUWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZEAUWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:22:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbZEAUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:22:06 -0400
Date: Fri, 1 May 2009 13:10:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, rmk+lkml@arm.linux.org.uk,
       cooloney@kernel.org, starvik@axis.com, takata@linux-m32r.org,
       geert@linux-m68k.org, zippel@linux-m68k.org, lethal@linux-sh.org,
       magnus.damm@gmail.com, wli@holomorphy.com, rth@twiddle.net
Subject: Re: [RESEND][PATCH 2/2] Convert sh to use arch_getoffset()
 infrastructure.
Message-Id: <20090501131006.fa631417.akpm@linux-foundation.org>
In-Reply-To: <1239759393.6064.30.camel@localhost>
References: <1239759163.6064.25.camel@localhost>
	<1239759251.6064.27.camel@localhost>
	<1239759393.6064.30.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 18:36:33 -0700
john stultz <johnstul@us.ibm.com> wrote:

> This patch converts sh to use GENERIC_TIME via the arch_getoffset()
> infrastructure 
> 
> I have tried cross-compiling this for sh3 and sh4. Also little has
> changed since my last submission where it was acked. So I've taken my
> best swing at converting this, but I'm not 100% confident I got it
> right. Any assistance from arch maintainers or testers would be great.

arch/sh/kernel/timers/timer-cmt.c has just vanished from linux-next and
I didn't find it popping up anywhere else, so I simply dropped that hunk
from the patch.

I'll send these patches at Thomas before they bitrot any further.

What's the status of
clocksource-sanity-check-sysfs-clocksource-changes.patch, btw?  I have
it marked as "still an RFC", but it's been sitting here since January?

