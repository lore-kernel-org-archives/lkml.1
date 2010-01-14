Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631Ab0ANJ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0ANJ0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676Ab0ANJ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:26:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37350 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab0ANJ00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:26:26 -0500
Date: Thu, 14 Jan 2010 10:26:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next: manual merge of the tip tree with the kgdb tree
Message-ID: <20100114092600.GA13503@elte.hu>
References: <20100114161302.285ebe27.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114161302.285ebe27.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> kernel/trace/trace.c between commit
> d304af88a0105ff5b64cffc9108636ecad1fdd78 ("ftrace,kdb: Extend kdb to be
> able to dump the ftrace buffer") from the kgdb tree and commit
> 7e53bd42d14c75192b99674c40fcc359392da59d ("tracing: Consolidate
> protection of reader access to the ring buffer") from the tip tree.

Hm, Jason, what is that large commit to kernel/trace/ doing in the KGDB tree, 
without any apparent acks from the affected people?

I dont see it anywhere on lkml nor in my mbox. Please submit it to the 
affected maintainers - for the Cc: line see the output of:

  scripts/get_maintainer.pl -f kernel/trace/trace.c

Thanks,

	Ingo
