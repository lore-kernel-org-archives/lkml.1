Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbYKQUQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbYKQUQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYKQUQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:16:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60746
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbYKQUQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:16:41 -0500
Date: Mon, 17 Nov 2008 12:16:41 -0800 (PST)
Message-Id: <20081117.121641.167690467.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0811171149100.18283@nehalem.linux-foundation.org>
References: <20081117184951.GA5585@elte.hu>
	<20081117.113936.81699150.davem@davemloft.net>
	<alpine.LFD.2.00.0811171149100.18283@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Nov 2008 11:55:35 -0800 (PST)

> So try to figure out why his (better) profile doesn't match your 
> (inferior) one, instead of asking him to do stupid things. It's some 
> difference in architectures, likely: maybe the sparc timekeeping is crap, 
> maybe it's a cache issue and sparc caches are crap, maybe it's something 
> where Niagara (is it niagara) has some oddness that shows up because it 
> has that odd four-threads+four-cores or whatever.

It's on my workstation which is a much simpler 2 processor
UltraSPARC-IIIi (1.5Ghz) system.

And yes I will investigate, it's all I've been doing in my
spare time these past few weeks.
