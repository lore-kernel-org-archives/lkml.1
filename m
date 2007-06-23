Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbXFWRQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbXFWRQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbXFWRQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:16:22 -0400
Received: from mail.screens.ru ([213.234.233.54]:53744 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760608AbXFWRQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:16:20 -0400
Date: Sat, 23 Jun 2007 21:17:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
Message-ID: <20070623171700.GB2346@tv-sign.ru>
References: <20070622182051.859570787@goodmis.org> <20070622182315.571740041@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622182315.571740041@goodmis.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

minor nitpick,

On 06/22, Steven Rostedt wrote:
>
> +void takeover_tasklets(unsigned int cpu)
> +{
> +}

Since you don't use config option any longer, I think it is better
to just kill this function and fix it's only caller.

You can also kill the declaration of tasklet_kill_immediate() in
tasklet.h.

Oleg.

