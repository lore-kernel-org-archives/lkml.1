Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0BVJO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:14:27 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:50854 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0BVJO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:14:26 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002220112q351044a4ycf4ee7dc2630c16d@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266749023.5468.1.camel@jlt3.sipsolutions.net>
	 <7b6bb4a51002210255t5ceaeb84r1438461085446385@mail.gmail.com>
	 <7b6bb4a51002210312o2a1d070aneb54c107aeab6952@mail.gmail.com>
	 <1266750881.10419.1.camel@jlt3.sipsolutions.net>
	 <1266751349.10419.2.camel@jlt3.sipsolutions.net>
	 <2375c9f91002220034m1beec51co7385a1cdbbcce7d2@mail.gmail.com>
	 <1266829490.5609.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002220112q351044a4ycf4ee7dc2630c16d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 10:14:11 +0100
Message-ID: <1266830051.5609.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 17:12 +0800, Américo Wang wrote:

> Since it hangs in put_cpu() which is just preempt_enable(), so I began
> to suspect if we need a synchronize_sched(), or some barrier perhaps.
> I am not sure at all.

Right.

> Before other experts look at this, I think doing a bisect would be
> very useful.

I was afraid you'd say that, it'll take forever though since I need to
walk over to it after every shutdown, see if it turned off and then turn
it on again (and possibly off).... I guess I'll get started on that.

johannes

