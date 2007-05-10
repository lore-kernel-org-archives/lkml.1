Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbXEJBAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbXEJBAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXEJBAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:00:32 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:45572 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757832AbXEJBAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:00:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=TM1ln5eP2O+HN7mud6ck057vkg8QZMery6aPPRrtGSF15yN3wS+U5jRJ6st9GsvcRHFcUkB+eiRpVLD5WxhLDH87P9j3G8FufF8l/RXVt5N9ZTqFx8Sm87Er8K5C3e1GAKpSnTxHrxB3yeKJATP0h58+tXLEhxCkfy0zJ3cdb4I=  ;
X-YMail-OSG: tWPi_XoVM1l6EN40oE5T7cNPLm8HEdxJdKAHTkK299UR4E6vmAN.urM7_er.JJRdS54jALFK9Q--
Message-ID: <46426EA1.4030408@yahoo.com.au>
Date: Thu, 10 May 2007 11:00:17 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, clameter@sgi.com, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>	<20070509012725.GZ11115@waste.org>	<Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>	<20070508.185141.85412154.davem@davemloft.net>	<46412BB5.1060605@yahoo.com.au> <20070509174238.b4152887.akpm@linux-foundation.org>
In-Reply-To: <20070509174238.b4152887.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 09 May 2007 12:02:29 +1000
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>BTW, we _really_ should be doing RCU properly in slob, because you
>>technically can't noop RCU on UP (even though the current users may be
>>safe...).
>>
>>Patch attached to do that.
> 
> 
> Does it work?

That one booted my desktop (very slowly) but as Matt pointed out, it broke
alignment on RCU slabs. The last version I posted should work and has the
alignment problem fixed. I can retest and resubmit it to you if you like,
I was just waiting on an ack from Matt.

-- 
SUSE Labs, Novell Inc.
