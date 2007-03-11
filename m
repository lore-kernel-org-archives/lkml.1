Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbXCKHcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbXCKHcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 03:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXCKHcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 03:32:50 -0400
Received: from 1wt.eu ([62.212.114.60]:1118 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbXCKHct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 03:32:49 -0400
Date: Sun, 11 Mar 2007 08:32:28 +0100
From: Willy Tarreau <w@1wt.eu>
To: Matt Mackall <mpm@selenic.com>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: RSDL-mm 0.28
Message-ID: <20070311073228.GM943@1wt.eu>
References: <20070311013506.GD10459@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311013506.GD10459@waste.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 07:35:06PM -0600, Matt Mackall wrote:
> I've tested -mm2 against -mm2+noyield and -mm2+rsdl+noyield. The
> noyield patch simply makes the sched_yield syscall return immediately.
> Xorg and all tests are run at nice 0.

[skipped long and precise test report]

> Also note I could occassionally trigger nasty multi-second pauses with
> -mm2+noyield under exectest that didn't show up elsewhere. That's
> probably a bug in the mainline scheduler.

This is not a bug per se, but more a design problem. This is caused by
the interactivity booster which is unfair. Mike Galbraith and others
spent a lot of time trying to get rid of those problems a few versions
ago. In early kernels (around 2.6.11), I could trivially cause pauses
more than 30 seconds long by running a few tasks simulating an interactive
workload. It is much more difficult to achieve this with recent kernels,
and it has absolutely no effect on RSDL, which is one of the reasons
I have to find it great !

Regards,
Willy

