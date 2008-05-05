Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYEEICa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYEEICa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYEEICK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:02:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45375
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbYEEICG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:02:06 -0400
Date: Mon, 05 May 2008 01:02:05 -0700 (PDT)
Message-Id: <20080505.010205.136409582.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, samuel@sortiz.org, dtor_core@ameritech.net
Subject: Re: [patch] irda: fix !PNP support in drivers/net/irda/nsc-ircc.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080505075823.GA9299@elte.hu>
References: <20080503193222.GA23373@elte.hu>
	<20080505.005003.69528106.davem@davemloft.net>
	<20080505075823.GA9299@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 5 May 2008 09:58:23 +0200

> i just used the existing precedent of doing the #ifdef: it's not _that_ 
> bad as it surrounds a single function most of the time so it's rather 
> apparent what is happening - and that is what is done in some other 
> drivers as well.
> 
> btw., when i fixed this i almost implemented it the way that you 
> suggested, but there's also a code size argument to when the suspend 
> callbacks are not used: the extra dummy function takes up text space, 
> and people turn off PNP when they build some specialized thing and try 
> to reduce the size of the kernel.
> 
> but in any case, i have no strong feelings in either direction.

The existing practice is ugly :-)

But I see arguments for either side, just like you.

Meanwhile let's fix this build error, I'll toss your patches
into my net-2.6 tree.

Thanks.
