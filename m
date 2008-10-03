Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYJCGx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYJCGx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYJCGxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:53:49 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:31529 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754152AbYJCGxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:53:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VYnmJpFa3hf1zxqFQenV8I7FZw99JHQmohPCTiBBUJAngA9qxGwlhlTSNrp380JsldCWaUz/ueNA5zEyvVyQfUvm1886MfkV9uv4WdMLrkl6HZl1sNWGyoelU5La966jfMzM019bFlYlYLHFzh/q77O1QBXZtun/Kt1KabS7HS0=  ;
X-YMail-OSG: AJiyl78VM1knW07yRvaDeYn0EGZ_7UtE71ah_IiMf3xUBsMwKHb9FcqGQFYiZ7waQzOnmVi9dPv2tmpIpIZ0vlNlzO6eV.kGE..vxNWJyduaNBExOo8kW0CLhq.lqoM2Px0x8qVc_0knh2XaVPlnZ6LGlKimFdrA82VKpbfWdR0TMyjG1zU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/32] Swap over NFS - v19
Date: Fri, 3 Oct 2008 16:53:39 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
References: <20081002130504.927878499@chello.nl> <20081002124748.638c95ff.akpm@linux-foundation.org>
In-Reply-To: <20081002124748.638c95ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031653.39639.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 05:47, Andrew Morton wrote:
> On Thu, 02 Oct 2008 15:05:04 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> 
wrote:
> > Let's get this ball rolling...
>
> I don't think we're really able to get any MM balls rolling until we
> get all the split-LRU stuff landed.  Is anyone testing it?  Is it good?

Peter's patches are very orthogonal to that work and shouldn't
actually change those kinds of reclaim heuristics at all.
