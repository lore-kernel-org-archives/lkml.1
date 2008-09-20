Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYITEx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYITEx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 00:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYITExT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 00:53:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYITExS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 00:53:18 -0400
Date: Sat, 20 Sep 2008 06:52:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] fastboot: fix mismerged conflict in init/main.c
Message-ID: <20080920045258.GA16047@elte.hu>
References: <20080919194215.12fe4c75@infradead.org> <20080919215014.37e2196d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919215014.37e2196d@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: [PATCH] fastboot: fix mismerged conflict in init/main.c
> 
> ok turns out it was a real conflict, not a mismerge. I've just fixed it
> and pushed out my git tree.
> 
> The following changes since commit
> 77e9695b9d5c9ce761dedc193045d9cb64b8e245: Arjan van de Ven (1):
>         Add a script to visualize the kernel boot process / time
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git
> master
> 
> Arjan van de Ven (2):
>       fastboot: fix issues and improve output of bootgraph.pl
>       use the fancy new printk flags to print the function pointer
> 
> Arnaud Patard (1):
>       fastboot: Fix bootgraph.pl initcall name regexp
> 
>  init/main.c          |    8 +++-----
>  scripts/bootgraph.pl |   33 +++++++++++++++++++++------------
>  2 files changed, 24 insertions(+), 17 deletions(-)

pulled into tip/fastboot, thanks Arjan!

	Ingo
