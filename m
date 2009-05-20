Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZETLaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZETLaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbZETLUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52138 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbZETLU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:20:27 -0400
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class citizen
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.10.0905181045340.20244@qirst.com>
	<20090519032759.GA7608@localhost>
	<20090519133422.4ECC.A69D9226@jp.fujitsu.com>
	<20090519062503.GA9580@localhost>
Date: Wed, 20 May 2009 13:20:24 +0200
In-Reply-To: <20090519062503.GA9580@localhost> (Wu Fengguang's message of "Tue, 19 May 2009 14:25:03 +0800")
Message-ID: <87pre4nhqf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> writes:
>
> 2.6.30-rc4-mm, VM_EXEC protection ON
> ------------------------------------
> begin:       2444             6652            50021              207                0           619959
> end:          284           231752           233394              210           773879         20890132
> restore:      399           231973           234352              251           776879         20960568
>
> We can reach basically the same conclusion from the above data.

One scenario that might be useful to test is what happens when some very large
processes, all mapped and executable exceed memory and fight each other
for the working set. Do you have regressions then compared to without
the patches?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
