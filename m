Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbYDCVLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbYDCVLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbYDCVLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:11:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756684AbYDCVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:11:32 -0400
Date: Thu, 3 Apr 2008 14:11:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Introduce CLOCK_MONOTONIC_RAW
Message-Id: <20080403141106.51528643.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804021340290.26791@localhost.localdomain>
References: <1205878279.28128.114.camel@localhost>
	<1205878420.28128.117.camel@localhost>
	<Pine.LNX.4.64.0804021340290.26791@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 13:50:36 +0200 (CEST)
Roman Zippel <zippel@linux-m68k.org> wrote:

> On Tue, 18 Mar 2008, john stultz wrote:
> 
> > My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
> > nanosecond based time value, that increments starting at bootup and has
> > no frequency adjustments made to it what so ever.
> > 
> > The time is accessed from userspace via the posix_clock_gettime()
> > syscall, passing CLOCK_MONOTONIC_RAW as the clock_id.
> 
> This is a reworked version of this patch based on the previous 
> clocksource_forward_now patch, since clocksource_forward_now() takes 
> care of the time offset now, it's not needed to do this at various places.
> I also got rid of the monotonic_raw splitting, so the work done during 
> update_wall_time() is quite a bit simpler.

All right, I give up.  I dropped

clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-keep-track-of-original-clocksource-frequency-fix.patch
clocksource-introduce-clock_monotonic_raw.patch
clocksource-introduce-clock_monotonic_raw-fix.patch
clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch
clocksource-introduce-clocksource_forward_now.patch

Please someone resend everything from scratch when it's all sorted out.
