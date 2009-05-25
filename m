Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbZEYHnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbZEYHnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbZEYHnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:43:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49542
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbZEYHm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:42:59 -0400
Date: Mon, 25 May 2009 00:42:58 -0700 (PDT)
Message-Id: <20090525.004258.82412594.davem@davemloft.net>
To: mike@it-loops.com
Cc: buytenh@wantstofly.org, afleming@freescale.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH,RFC] gianfar: fix BUG under load after introduction of
 skb recycling
From: David Miller <davem@davemloft.net>
In-Reply-To: <2A79CAF4-334F-4763-82E3-2460377F3078@it-loops.com>
References: <20090523115143.GB1672@mail.wantstofly.org>
	<2A79CAF4-334F-4763-82E3-2460377F3078@it-loops.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Guntsche <mike@it-loops.com>
Date: Sun, 24 May 2009 17:32:05 +0200

> 
> On May 23, 2009, at 13:51, Lennert Buytenhek wrote:
> 
>> Since commit 0fd56bb5be6455d0d42241e65aed057244665e5e ("gianfar:
>> Add support for skb recycling"), gianfar puts skbuffs that are in
>> the rx ring back onto the recycle list as-is in case there was a
>> receive error, but this breaks the following invariant: that all
>> skbuffs on the recycle list have skb->data = skb->head + NET_SKB_PAD.
>>
>>
>> Michael, can you re-test with this version of the patch?
>> Andy, can you see if this is OK with you?
> 
> Hi, I have been running tests with this patch for the last 6 hours and
> had no panics so far.
> So it fixes the issues I am seeing as well.

Since it's now tested, I am applying this to net-2.6 to expedite it's
inclusion into 2.6.30

Thanks.
