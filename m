Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375Ab0ADJtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0ADJtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 04:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203Ab0ADJtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 04:49:14 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:51595 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752217Ab0ADJtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 04:49:14 -0500
Date: Mon, 4 Jan 2010 10:49:04 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: might_sleep(): Make file parameter
 const char *
Message-ID: <20100104104904.65f57a24@marrow.netinsight.se>
In-Reply-To: <1262088708.7135.133.camel@laptop>
References: <20091223110818.442d848e@marrow.netinsight.se>
	<tip-d894837f23f491aa7ed167aae767fc07cfe6e6e6@git.kernel.org>
	<1262088708.7135.133.camel@laptop>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Back from vacation, hence the delayed response)

On Tue, 29 Dec 2009 13:11:48 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-12-28 at 10:10 +0000, tip-bot for Simon Kagstrom wrote:
> 
> > Fixes a warning when building with g++:
> 
> However did you manage to build stuff with g++? The kernel very
> frequently uses C++ keywords for other things.

I expected this question :-)

Yes, there are some workarounds we have to make to get it compiling
(like #define new NEW prior to including the headers), but it works
out. I know this is something you shouldn't do, and I debated whether
to mention C++ at all. 


Anyway, I think the change itself makes sense for plain C as well. The
comment just described the context where it showed up for us.

// Simon
