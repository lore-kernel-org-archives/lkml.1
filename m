Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZDMBNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZDMBNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 21:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZDMBNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:13:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39818
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbZDMBNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:13:40 -0400
Date: Sun, 12 Apr 2009 18:13:30 -0700 (PDT)
Message-Id: <20090412.181330.23529546.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: paulus@samba.org, mingo@elte.hu, torvalds@linux-foundation.org,
       laijs@cn.fujitsu.com, shemminger@vyatta.com, jeff.chua.linux@gmail.com,
       dada1@cosmosbay.com, jengelh@medozas.de, kaber@trash.net,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: iptables very slow after commit
 784544739a25c30637397ace5489eeb6e15d7d49
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090412173108.GO6822@linux.vnet.ibm.com>
References: <20090411174801.GG6822@linux.vnet.ibm.com>
	<18913.53699.544083.320542@cargo.ozlabs.ibm.com>
	<20090412173108.GO6822@linux.vnet.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 12 Apr 2009 10:31:08 -0700

> On Sun, Apr 12, 2009 at 09:34:27PM +1000, Paul Mackerras wrote:
>> Paul E. McKenney writes:
>> 
>> > If the generic implementation is needed only on !SMP systems, that
>> > could work.  The architectures I would be worried about include
>> > powerpc and ia64, which I believe support 32-bit SMP builds.
>> 
>> 32-bit powerpc doesn't have 64-bit atomic operations and does support
>> SMP.
>> 
>> What about ARM?  I thought they had 32-bit SMP these days as well.
> 
> Some of Steve Hemminger's recent suggestions in this thread seem to me
> to avoid this whole issue nicely.  But we will see!  ;-)

I hope so.

Eventually it seems that all of the older 32-bit SMP platforms
will be run under a bus having to execute some many "efficient"
primitives using the "hash table of spinlocks" scheme for
synchronization.
