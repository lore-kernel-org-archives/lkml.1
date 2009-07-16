Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbZGPJyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbZGPJyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZGPJyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:54:12 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:59043 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZGPJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:54:12 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RESEND PATCH 0/11] kernel:lockdep:replace DFS with BFS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <d82e647a0907160012p4f4ee559q1a04be4cfbc4753c@mail.gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1247476574.7529.55.camel@twins>
	 <d82e647a0907152139x12edd66agde44f155fa60506b@mail.gmail.com>
	 <1247721753.15471.2.camel@twins>
	 <d82e647a0907160012p4f4ee559q1a04be4cfbc4753c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 11:54:22 +0200
Message-Id: <1247738062.15471.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 15:12 +0800, Ming Lei wrote:
> 2009/7/16 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> >
> > I've asked several times to comment on the removal of that generation
> > count DaveM did. Is that a normal part of DFS, or was that an
> > optimization on top particular to this problem, can something similar be
> > done for BFS, etc.
> 
> DFS uses generation count DaveM did to decide if a class is visted, and BFS
> uses bitmap to mark a class is visted or not and the extra efficiency loss is
> 
>           bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
> 
> before staring each BFS.
> 
> On most of ARCH, bimap_zero can be optimizied to only consume very few
> instructions,
> can't it?
> 
> It seems bitmap is more easily used in BFS than generation count.

Ah, I so missed that, sorry about that.

I'll go over the patches one more time and push them out.

Thanks!

