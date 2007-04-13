Return-Path: <linux-kernel-owner+w=401wt.eu-S1030470AbXDMVVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470AbXDMVVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030476AbXDMVVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:21:00 -0400
Received: from holomorphy.com ([66.93.40.71]:38796 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030470AbXDMVVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:21:00 -0400
Date: Fri, 13 Apr 2007 14:21:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413212110.GU2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <20070413202745.GA17993@gnuppy.monkey.org> <20070413205545.GA18032@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413205545.GA18032@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 10:55:45PM +0200, Ingo Molnar wrote:
> Yeah. Note that there are some subtle but crutial differences between 
> PlugSched (which Con used, and which i opposed in the past) and this 
> approach.
> PlugSched cuts the interfaces at a high level in a monolithic way and 
> introduces kernel/scheduler.c that uses one pluggable scheduler 
> (represented via the 'scheduler' global template) at a time.

What I originally did did so for a good reason, which was that it was
intended to support far more radical reorganizations, for instance,
things that changed the per-cpu runqueue affairs for gang scheduling.
I wrote a top-level driver that did support scheduling classes in a
similar fashion, though it didn't survive others maintaining the patches.


-- wli
