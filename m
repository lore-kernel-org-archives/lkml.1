Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbXEUKEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbXEUKEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbXEUKDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:03:55 -0400
Received: from mx12.go2.pl ([193.17.41.142]:44062 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755401AbXEUKDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:03:54 -0400
Date: Mon, 21 May 2007 12:10:40 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070521101040.GC1695@ff.dom.local>
References: <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515220024.GA615@tv-sign.ru> <464AEA47.7030600@gmail.com> <20070516185203.GB81@tv-sign.ru> <20070518073517.GB1573@ff.dom.local> <464DAB3D.4020000@gmail.com> <20070521070036.GA1695@ff.dom.local> <46515F82.9070606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46515F82.9070606@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 10:59:46AM +0200, Tejun Heo wrote:
...
> Well, it might be just because I'm used to what I call 'locked
> enter/leave' model.  If people don't find that easier to understand, no
> objection from me and kudos to Oleg for getting it right from the beginning.

I think most people here, at least me too, are used to the same.
At first I didn't even think whether Oleg's feelings about these
barriers were right - it was obvious to me any barriers (!) should
be avoided.

But while reading David's manual I started to doubt: there had to
be some reasons these CPUs were done such nasty way. And probably
it wasn't about punishing the programmers. So, maybe sometimes
good, old habits aren't the best advisors...

Cheers,
Jarek P.
