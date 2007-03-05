Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbXCEXL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbXCEXL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXCEXL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:11:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40618 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbXCEXLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:11:25 -0500
Date: Mon, 5 Mar 2007 15:11:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.A. =?ISO-8859-1?Q?Magall=F3n" ?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070305151120.e5eab328.akpm@linux-foundation.org>
In-Reply-To: <20070305232058.6eeeb254@werewolf-wl>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<20070305232058.6eeeb254@werewolf-wl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007 23:20:58 +0100
"J.A. Magall__n" <jamagallon@ono.com> wrote:

> On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> > 
> > 
> 
> I'm also noticing very bad behaviour wrt scheduling, I think. When I launch my
> parallel cpu burning code, the system _really_ stalls, the mouse in X11 is not
> jerky, it is _stuck_ for a couple or three seconds...
> 
> The only diffrecence is that, trying to solve nVidia driver problems, I disabled
> BKL preemption:
> 
> werewolf:/usr/src/linux# grep PREEMPT .config
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> # CONFIG_PREEMPT_BKL is not set

Do you think that is a problem which is introduced by -rc1-mm1?

It'd be good if you can capture the `top' output while this is happening -
it could be the longstanding problem where an app's sleep/run pattern
permits it to get a lot of dynamic priority boosting, even though it is
CPU-intensive.

