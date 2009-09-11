Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZIKQhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZIKQhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZIKQhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:37:32 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41190 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbZIKQhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:37:31 -0400
Date: Fri, 11 Sep 2009 18:37:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, peterz@infradead.org,
       yanmin_zhang@linux.intel.com, torvalds@linux-foundation.org
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
	performance
Message-ID: <20090911163733.GL14984@kernel.dk>
References: <20090911174019.1ed02737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911174019.1ed02737@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] cpuidle: A new variant of the menu governor
> 
> This patch adds a new idle governor which balances power savings,
> energy efficiency and performance impact.
> 
> The reason for a reworked governor is that there have been
> serious performance issues reported with the existing code
> on Nehalem server systems.
> 
> To show this I'm sure Andrew wants to see benchmark results:
> (benchmark is "fio", "no cstates" is using "idle=poll")
> 
> 		no cstates	current linux	new algorithm
> 1 disk		107 Mb/s	85 Mb/s		105 Mb/s
> 2 disks		215 Mb/s	123 Mb/s	209 Mb/s
> 12 disks	590 Mb/s	320 Mb/s	585 Mb/s

Heh that's interesting, I have noticed some oddities that I haven't
pursued further yet. But it was definitely power state related, so I'll
give your patch spin.

-- 
Jens Axboe

