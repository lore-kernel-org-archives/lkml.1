Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZEXPcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZEXPcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbZEXPcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:32:10 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:36202
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbZEXPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:32:08 -0400
Cc: Andy Fleming <afleming@freescale.com>, davem@davemloft.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Message-Id: <2A79CAF4-334F-4763-82E3-2460377F3078@it-loops.com>
From: Michael Guntsche <mike@it-loops.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20090523115143.GB1672@mail.wantstofly.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH,RFC] gianfar: fix BUG under load after introduction of skb recycling
Date: Sun, 24 May 2009 17:32:05 +0200
References: <20090523115143.GB1672@mail.wantstofly.org>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 23, 2009, at 13:51, Lennert Buytenhek wrote:

> Since commit 0fd56bb5be6455d0d42241e65aed057244665e5e ("gianfar:
> Add support for skb recycling"), gianfar puts skbuffs that are in
> the rx ring back onto the recycle list as-is in case there was a
> receive error, but this breaks the following invariant: that all
> skbuffs on the recycle list have skb->data = skb->head + NET_SKB_PAD.
>
>
> Michael, can you re-test with this version of the patch?
> Andy, can you see if this is OK with you?

Hi, I have been running tests with this patch for the last 6 hours and  
had no panics so far.
So it fixes the issues I am seeing as well.

Hope this helps,
Michael
