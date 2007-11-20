Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXKTFYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXKTFYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXKTFYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:24:43 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:38282 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752113AbXKTFYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:24:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vDyjxxFmxhUUDTpdJ73rx1vZczNFc5nZYg8DBYePwji8eZlDwEqHDllTmS0j82gBlJHNfZFPdsGYgCT9vLiOTkaXxzvPTotAmAruMAHpJzPfrdlCnZreYTXXdVT/iWttPiGmDyJIwggbRd9hoZORaynl828CrOER5R3MSpFGLBs=  ;
X-YMail-OSG: .paDt58VM1k4gASYw6tf4INExQsl4PBZmrlJ9OnDTd4.D4hrn2e0d7lY7RSrkJ9Qn8lruaC7Rw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Date: Tue, 20 Nov 2007 16:24:32 +1100
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <47425EA5.7000607@rtr.ca> <20071120042929.GD15227@1wt.eu> <20071120043742.GE6164@stusta.de>
In-Reply-To: <20071120043742.GE6164@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201624.32611.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 15:37, Adrian Bunk wrote:
> On Tue, Nov 20, 2007 at 05:29:29AM +0100, Willy Tarreau wrote:

> > Agreed. When userspace has something to do with the way IRQs are
> > delivered, it's going to smell as bad as micro-kernels...
>
> The next step to a micro-kernel would then be hardware drivers and file
> systems in userspace?  ;-)

We already have those. So the next step would be to pretend the
performance critical ones can be in userspace and remain competitive,
wouldn't it? ;)
