Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbXKHCrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbXKHCrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbXKHCrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:47:12 -0500
Received: from waste.org ([66.93.16.53]:48605 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760659AbXKHCrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:47:10 -0500
Date: Wed, 7 Nov 2007 20:44:26 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marin Mitov <mitov@issp.bas.bg>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Message-ID: <20071108024425.GR19691@waste.org>
References: <200711071921.52330.mitov@issp.bas.bg> <200711080131.01243.ak@suse.de> <20071108010347.GP19691@waste.org> <200711080220.59086.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711080220.59086.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 02:20:58AM +0100, Andi Kleen wrote:
> 
> > But I think we'd be best off stashing a single bit somewhere and
> > checking it at migrate time (relatively infrequent) rather than
> > copying and zeroing out a potentially enormous affinity mask every
> > time we disable migration (often, and in fast paths). Perhaps adding
> > TASK_PINNED to the task state flags would do it?
> 
> It would need to be a count to be able to nest it.

Ahh, right. Suppose that means fattening the task struct until someone
comes up with something more clever.

-- 
Mathematics is the supreme nostalgia of our time.
