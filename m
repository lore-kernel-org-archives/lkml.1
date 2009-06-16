Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZFPJsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZFPJsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZFPJsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:48:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40768 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZFPJsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:48:21 -0400
Date: Tue, 16 Jun 2009 11:48:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20090616094813.GA1686@elte.hu>
References: <20090615.050449.144947903.davem@davemloft.net> <20090616091538.GA4184@elte.hu> <20090616.021955.243374916.davem@davemloft.net> <20090616104417.657d6682@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616104417.657d6682@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 16 Jun 2009 02:19:55 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 16 Jun 2009 11:15:38 +0200
> > 
> > >  [<ffffffff810489e6>] __might_sleep+0xf6/0x120
> > >  [<ffffffff81b3921d>] lock_sock_nested+0x3d/0x120
> > >  [<ffffffff81c1a7d2>] x25_destroy_socket+0x22/0x180
> > >  [<ffffffff81c1aa4e>] x25_destroy_timer+0xe/0x10
> > >  [<ffffffff81060619>] run_timer_softirq+0x1d9/0x2e0
> > >  [<ffffffff81060560>] ? run_timer_softirq+0x120/0x2e0
> > 
> > What on your system is openning x25 sockets?  Some stress/torture
> > program that opens random sockets?
> > 
> > Or have you gotten into packet radio recently? :-)
> 
> packet radio is AX.25
> 
> X.25 is the CCITT wired network protocol over HDLC/LAP-B

I think David's larger point was that what looked to me like more 
widespread breakage was in fact limited to [a]x25, a comparatively 
rarely used (and rarely tested) corner of the kernel.

I turned them off and that solved the problems here. (and i suspect 
the real fix wont be far away either) Thanks everyone.

	Ingo
