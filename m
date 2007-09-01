Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbXIAWK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbXIAWK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXIAWKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:10:48 -0400
Received: from ns.suse.de ([195.135.220.2]:45118 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbXIAWKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:10:47 -0400
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "CK Mailinglist" <ck@vds.kolivas.org>
Subject: Re: [ANNOUNCE] DeskOpt - on fly task, i/o scheduler optimization
References: <46D8354A.3030208@googlemail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Sep 2007 00:10:46 +0200
In-Reply-To: <46D8354A.3030208@googlemail.com>
Message-ID: <p73y7fqvxy1.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski <michal.k.k.piotrowski@gmail.com> writes:

> Here is something that might be useful for gamers and audio/video editors
> http://www.stardust.webpages.pl/files/tools/deskopt/

To make it double cool combine that with the generic genetic 
optimizer for parameters that was posted a couple of months ago.

> 
> You can easily tune CFS/CFQ scheduler params
> 
> sched_batch_wakeup_granularity_ns
> sched_latency_ns
> sched_min_granularity_ns
> sched_runtime_limit_ns
> sched_stat_granularity_ns
> sched_wakeup_granularity_ns
> 
> back_seek_max
> back_seek_penalty
> fifo_expire_async
> fifo_expire_sync
> quantum
> slice_async
> slice_async_rq
> slice_idle
> slice_sync
> 

You should probably add the device queue length too. That seems
to often have a large impact on IO scheduling because on modern
long queue controllers the Linux IO scheduler often doesn't
have much to do because the device queue just eats it all up quickly.

-Andi
