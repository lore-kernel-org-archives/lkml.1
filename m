Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZIKTbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZIKTbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZIKTbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:31:15 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:55716 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbZIKTbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:31:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19114.41505.479086.782442@stoffel.org>
Date: Fri, 11 Sep 2009 15:16:49 -0400
From: "John Stoffel" <john@stoffel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, peterz@infradead.org,
       yanmin_zhang@linux.intel.com, torvalds@linux-foundation.org,
       jens.axboe@oracle.com
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
In-Reply-To: <20090911174019.1ed02737@infradead.org>
References: <20090911174019.1ed02737@infradead.org>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Arjan" == Arjan van de Ven <arjan@infradead.org> writes:

Arjan> From: Arjan van de Ven <arjan@linux.intel.com>
Arjan> Subject: [PATCH] cpuidle: A new variant of the menu governor

Arjan> This patch adds a new idle governor which balances power savings,
Arjan> energy efficiency and performance impact.

Arjan> The reason for a reworked governor is that there have been
Arjan> serious performance issues reported with the existing code
Arjan> on Nehalem server systems.

Arjan> To show this I'm sure Andrew wants to see benchmark results:
Arjan> (benchmark is "fio", "no cstates" is using "idle=poll")

Arjan> 		no cstates	current linux	new algorithm
Arjan> 1 disk		107 Mb/s	85 Mb/s		105 Mb/s
Arjan> 2 disks		215 Mb/s	123 Mb/s	209 Mb/s
Arjan> 12 disks	590 Mb/s	320 Mb/s	585 Mb/s

Don't you need another row or three where you show a) how much time
each test took, and b) how much (or average) power used for the
duration of the test?  

I'm just curious if the new algorithm (or even the current one!) saves
any appreciable power over the 'no cstates' case.  It's not clear what
the savings are.  

Also, latency in terms of switching to higher power and then back down
would be nice to see.

Cheers,
John
