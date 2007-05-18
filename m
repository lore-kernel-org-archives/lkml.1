Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXERIGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXERIGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbXERIGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:06:30 -0400
Received: from mx2.go2.pl ([193.17.41.42]:54378 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755478AbXERIG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:06:29 -0400
Date: Fri, 18 May 2007 10:13:08 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070518081308.GC1573@ff.dom.local>
References: <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515220024.GA615@tv-sign.ru> <464AEA47.7030600@gmail.com> <20070516185203.GB81@tv-sign.ru> <20070518073517.GB1573@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518073517.GB1573@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 09:35:17AM +0200, Jarek Poplawski wrote:
> On Wed, May 16, 2007 at 10:52:03PM +0400, Oleg Nesterov wrote:
...
> 3. The alternative solution without barriers, based on the
> idea of Tejun Heo and presented in the patch proposal from
> 2007-05-13, could be probably a little faster (for some
> processors), after some changes:

I mean "a little faster" than current version. Of course
the second change is needed for other, discussed reasons.

Jarek P.
