Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXHYVUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXHYVUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbXHYVUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 17:20:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39434 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXHYVUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 17:20:31 -0400
Subject: Re: [git pull request] scheduler updates
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070825172319.GA2080@elte.hu>
References: <20070824141215.GA24403@elte.hu>
	 <alpine.LFD.0.999.0708241105410.25853@woody.linux-foundation.org>
	 <20070824193758.GA6440@elte.hu>  <20070825172319.GA2080@elte.hu>
Content-Type: text/plain
Date: Sat, 25 Aug 2007 23:20:22 +0200
Message-Id: <1188076822.5405.13.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-25 at 19:23 +0200, Ingo Molnar wrote:

> Peter and me tested this all day with various workloads and extreme-load 
> behavior has improved all over the place
 
Adaptive granularity makes a large difference for me on my somewhat
ancient laptop (1200 MHz). When browsing the interweb using firefox (or
trying to) while doing a (non-niced) kbuild -j5 the difference in
interactivity is significant.
 
[ kbuild -j5 was quite unbearable on 2.6.22 - so CFS is a clear win in
any case ]
 
The reduced latency is clearly noticable in a much smoother scroll
behaviour. Whereas both still present a usable browsing experience the
clear reduction in latency spikes makes it much more pleasant.


