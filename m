Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbYDYH61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbYDYH61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYDYH6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:58:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57062
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754169AbYDYH6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:58:17 -0400
Date: Fri, 25 Apr 2008 00:58:16 -0700 (PDT)
Message-Id: <20080425.005816.249606540.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
From: David Miller <davem@davemloft.net>
In-Reply-To: <48118EAB.5040004@gmail.com>
References: <48118B73.6000700@gmail.com>
	<20080425.004943.148536408.davem@davemloft.net>
	<48118EAB.5040004@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 25 Apr 2008 09:56:27 +0200

> On 04/25/2008 09:49 AM, David Miller wrote:
> > Two hyperthreads per-core?
> 
> Hmm, how to find out? I suppose it will show up 4 (virtual) processors in 
> cpuinfo, right? Although there is ht bit in cpuinfo on each core and 
> CONFIG_X86_HT=y, I don't see 4 cpus.

Ok, good to know.

> > If so that could match up to the pattern.  It is just one theory
> > though.  The wireless possibility holds just as much weight.
> 
> The mac80211 is theory too so far :).

I'll try to do some commit mining of my own.

Thanks for all of the info so far.
