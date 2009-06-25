Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZFYQsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZFYQsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZFYQsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:48:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbZFYQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:48:29 -0400
Date: Thu, 25 Jun 2009 09:47:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
       davem@davemloft.net, dada1@cosmosbay.com, zbr@ioremap.net,
       jeff.chua.linux@gmail.com, paulus@samba.org, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, benh@kernel.crashing.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH -tip 0/3] expedited "big hammer" RCU grace periods
In-Reply-To: <20090625095953.GC29980@elte.hu>
Message-ID: <alpine.LFD.2.01.0906250944511.3605@localhost.localdomain>
References: <20090624164535.GA13334@linux.vnet.ibm.com> <20090624180303.GE7576@elte.hu> <20090624184423.GK6779@linux.vnet.ibm.com> <20090625095953.GC29980@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, Ingo Molnar wrote:
> 
> Our general preference is to zap code.
> 
> /me stares at:
> 
>   $ git diff --stat -M v2.6.30..v2.6.31-rc1 | tail -1
>   7743 files changed, 782278 insertions(+), 403162 deletions(-)
> 
> /me corrects himself:

Yes. Our general preference is to zap code, if only because it's so damn 
unusual.

When one out of a hundred patches actually has more removals than 
additions, we make a big deal out of it ("Look - I actually simplified 
things"). For the 99 other patches we never size in polite company.

Oh well. But every time we add lines, we do it with the _best_ intentions.

		Linus
