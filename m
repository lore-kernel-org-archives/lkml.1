Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXGDGdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXGDGdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXGDGde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:33:34 -0400
Received: from mx10.go2.pl ([193.17.41.74]:41572 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751565AbXGDGdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:33:33 -0400
Date: Wed, 4 Jul 2007 08:41:59 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S\. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Re: [NETPOLL] netconsole: fix soft lockup when removing module
Message-ID: <20070704064159.GA2057@ff.dom.local>
References: <20070701173558.GA207@tv-sign.ru> <20070702075226.GB1639@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702075226.GB1639@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 09:52:26AM +0200, Jarek Poplawski wrote:
> 
> From my recent patch:
> 
> > >    #1
> > >    Until kernel ver. 2.6.21 (including) cancel_rearming_delayed_work()
> > >    required a work function should always (unconditionally) rearm with
> > >    delay > 0 - otherwise it would endlessly loop. This patch replaces
> > >    this function with cancel_delayed_work(). Later kernel versions don't
> > >    require this, so here it's only for uniformity.
> 
> But Oleg Nesterov <oleg@tv-sign.ru> found:
> 
> > But 2.6.22 doesn't need this change, why it was merged?
> > 
> > In fact, I suspect this change adds a race,
> ...
> 
> His description was right (thanks), so this patch reverts #1.
> 
> Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

Oleg,

I think maybe you could ack these 2 netconsole patches...
They were done on your request but it looks like Andrew
is waiting on something...

Thanks,
Jarek P.
