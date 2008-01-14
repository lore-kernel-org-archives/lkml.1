Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYANHwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYANHwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 02:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYANHwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 02:52:11 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:47071 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYANHwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 02:52:09 -0500
Date: Mon, 14 Jan 2008 08:51:53 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mikael.starvik@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRIS v10: Correct do_signal to fix oops and clean up signal handling in general.
Message-ID: <20080114075153.GA3912@axis.com>
References: <20080111185923.GE27482@axis.com> <20080111154513.43c0d414.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111154513.43c0d414.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 03:45:13PM -0800, Andrew Morton wrote:
> On Fri, 11 Jan 2008 19:59:24 +0100
> Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> 
> > CRIS v10: Correct do_signal to fix oops and clean up signal handling in general.
> > 
> > This fixes a kernel panic on boot due to do_signal not being compatible
> > with it's callers.
> 
> Please sequence-number patches even if they are unrelated.  That will make
> emails like this one easier.

Yes, sorry about that, they should have been sequenced.

> 1: CRIS v10: Correct do_signal to fix oops and clean up signal handling in general.
> 2: CRIS: Define __ARCH_WANT_SYS_RT_SIGSUSPEND in unistd.h for CRIS
> 3: CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile.
> 4: CRIS v10: Driver for ds1302 needs to include cris-specific i2c.h
> 
> Patches 3 and 4 were missing your signed-off-by:.  I added it.
> 
> I queued patches 1, 3 and 4 for 2.6.24 and patch 2 for 2.6.25.  Do you agree?

All four should be queued for 2.6.24 since patch 2 is needed if patch 1
is included, otherwise sys_rt_sigsuspend will be undefined causing a
link error.

Thanks!

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
