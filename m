Return-Path: <linux-kernel-owner+w=401wt.eu-S934900AbYEBMXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934900AbYEBMXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933366AbYEBMXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:23:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794AbYEBMXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:23:37 -0400
Date: Fri, 2 May 2008 05:22:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Greg Ungerer <gerg@snapgear.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: ColdFire add support for kernel preemption
Message-Id: <20080502052235.eb9c336a.akpm@linux-foundation.org>
In-Reply-To: <20080502083755.GA13973@Chamillionaire.breakpoint.cc>
References: <200805010216.m412GT6t004096@goober>
	<20080501143336.552e39e1.akpm@linux-foundation.org>
	<481AC07A.6080707@snapgear.com>
	<20080502083755.GA13973@Chamillionaire.breakpoint.cc>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 10:37:55 +0200 Sebastian Siewior <lkml@ml.breakpoint.cc> wrote:

> >>> Subject: [PATCH] m68knommu: ColdFire add support for kernel preemption
> >> Please find a way to get your patch queue into linux-next so that others
> >> get some visibility into what you're brewing earlier than
> >> last-day-of-the-merge-window?
> >
> > Is a git tree the only way?
> Others (Greg KH for instance, i2c) have quilt queues.

Yup.  Examples:

ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
http://ozlabs.org/~rusty/kernel/rr-latest
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-usb

Note how you can publish subsets of your patchset by bracketing them with
"# MM_PATCHES_START" and "# MM_PATCHES_END" for -mm, and "#
NEXT_PATCHES_START" and "# NEXT_PATCHES_END" for linux-next.


