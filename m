Return-Path: <linux-kernel-owner+w=401wt.eu-S934503AbXHLJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934503AbXHLJtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933089AbXHLJor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:44:47 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:5568 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbXHLJop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:44:45 -0400
Subject: Re: [PATCH] make atomic_t volatile on all architectures
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>, wjiang@resilience.com,
       wensong@linux-vs.org, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, ak@suse.de, cfriesen@nortel.com,
       netdev@vger.kernel.org, horms@verge.net.au, akpm@linux-foundation.org,
       Chuck Ebbert <cebbert@redhat.com>, davem@davemloft.net, zlynx@acm.org,
       Chris Snook <csnook@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0708112305170.30176@woody.linux-foundation.org>
References: <20070808230733.GA17270@shell.boston.redhat.com>
	 <alpine.LFD.0.999.0708082116060.25146@woody.linux-foundation.org>
	 <46BAC2BE.1090106@redhat.com> <46BB508B.7050601@redhat.com>
	 <alpine.LFD.0.999.0708091055080.25146@woody.linux-foundation.org>
	 <1186683646.9669.20.camel@localhost>
	 <a599bc5062d557db46496f0d7c7886b0@kernel.crashing.org>
	 <alpine.LFD.0.999.0708112305170.30176@woody.linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 12 Aug 2007 11:48:18 +0200
Message-Id: <1186912098.3852.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-11 at 23:09 -0700, Linus Torvalds wrote: 
> Segher, how about you just accept that Linux uses gcc as per reality, and 
> that sometimes the reality is different from your expectations?
> 
> "+m" works. We use it. It's better than the alternatives. Pointing to 
> stale documentation doesn't change anything.

Well, perhaps on i386. I've seen some older versions of the s390 gcc die
with an ICE because I have used "+m" in some kernel inline assembly. I'm
happy to hear that this issue is fixed in recent gcc. Now I'll have to
find out if this is already true with gcc 3.x. The duplication "=m" and
"m" with the same constraint is rather annoying.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.



