Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753197AbYLRB5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYLRB5T (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYLRB5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:57:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbYLRB5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:57:02 -0500
Date: Wed, 17 Dec 2008 17:56:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] clocksource: pass clocksource to read() callback
Message-Id: <20081217175658.0706a07f.akpm@linux-foundation.org>
In-Reply-To: <20081211114802.17622.54609.sendpatchset@rx1.opensource.se>
References: <20081211114802.17622.54609.sendpatchset@rx1.opensource.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 20:48:02 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> Pass clocksource pointer to the read() callback for clocksources.
> This allows us to share the callback between multiple instances.

sparc64 allmodconfig:


  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-sparc
  CC      arch/sparc/kernel/asm-offsets.s
In file included from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/clocksource.h:16,
                 from /usr/src/devel/arch/sparc/include/asm/timer_64.h:11,
                 from /usr/src/devel/arch/sparc/include/asm/timer.h:4,
                 from /usr/src/devel/arch/sparc/include/asm/timex_64.h:9,
                 from /usr/src/devel/arch/sparc/include/asm/timex.h:4,
                 from include/linux/timex.h:170,
                 from include/linux/sched.h:54,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: division by zero in #if
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: division by zero in #if
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: division by zero in #if
include/linux/jiffies.h:247:31: division by zero in #if
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: division by zero in #if
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: division by zero in #if
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:247:31: division by zero in #if
