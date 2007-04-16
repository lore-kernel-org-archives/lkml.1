Return-Path: <linux-kernel-owner+w=401wt.eu-S1030963AbXDPVCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030963AbXDPVCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030965AbXDPVCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:02:07 -0400
Received: from ns.suse.de ([195.135.220.2]:39414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030963AbXDPVCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:02:04 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Apr 2007 00:00:07 +0200
In-Reply-To: <20070413202100.GA9957@elte.hu>
Message-ID: <p73tzvg56ag.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
> 
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
> 
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch

I would suggest to drop the tsc.c change. The "small errors" can be
really large on some systems and you can also see large backward jumps.
I have a proper (but complicated) solution pending
in ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/sched-clock-share

BTW with all this CPU time measurement it would be really nice to
report it to the user too. It seems a bit bizarre that the scheduler
keeps track of ns, but top only knows jiffies with large sampling errors.

-Andi
