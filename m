Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbXCQIls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbXCQIls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 04:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXCQIls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 04:41:48 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:49311 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbXCQIlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 04:41:47 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Nicholas Miell <nmiell@comcast.net>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RSDL v0.31
References: <200703042335.26785.a1426z@gawab.com>
	<200703170040.48316.kernel@kolivas.org>
	<1174059299.7886.25.camel@Homer.simpson.net>
	<200703170813.32594.kernel@kolivas.org>
	<1174084207.7009.9.camel@Homer.simpson.net>
	<1174105443.3144.4.camel@entropy>
	<1174110965.7911.44.camel@Homer.simpson.net>
	<1174112768.3144.8.camel@entropy> <20070317074506.GA13685@elte.hu>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
In-Reply-To: <20070317074506.GA13685@elte.hu> (Ingo Molnar's message of "Sat\, 17 Mar 2007 08\:45\:06 +0100")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
Date: Sat, 17 Mar 2007 11:41:32 +0300
Message-ID: <87fy84i7nn.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Nicholas Miell <nmiell@comcast.net> wrote:
>
>> The X people have plans for how to go about fixing this, [...]
>
> [...] Or will X regress forever once we switch to RSDL?) 
> We cannot regress the scheduling of a workload as important as "X mixed 
> with CPU-intense tasks". And "in theory this should be fixed if X is 
> fixed" does not cut it. X is pretty much _the_ most important thing to 
> optimize the interactive behavior of a Linux scheduler for. Also, 
> paradoxically, it is precisely the improvement of _X_ workloads that 
> RSDL argues with.
>
> this regression has to be fixed before RSDL can be merged, [...]

Let me restate the fact, if it wasn't obvious enough, that most people
who tried RSDL (and most of them use desktop systems, me including) never
see any regressions compared to mainline. Quite contrary -- their impressions
were that with RSDL desktop system runs more smoothly, even under fierce load,
which was never possible with mainline scheduler.

(see http://article.gmane.org/gmane.linux.kernel/504068 for a list
of references.)
