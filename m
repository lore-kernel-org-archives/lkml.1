Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZIQR3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZIQR3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZIQR3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:29:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35543
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbZIQR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:29:06 -0400
Date: Thu, 17 Sep 2009 10:29:23 -0700 (PDT)
Message-Id: <20090917.102923.174779685.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [crash] kernel BUG at net/core/pktgen.c:3503!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090915185112.GA17587@lenovo>
References: <20090911.202543.52533792.davem@davemloft.net>
	<20090915183647.GA11628@elte.hu>
	<20090915185112.GA17587@lenovo>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Tue, 15 Sep 2009 22:51:12 +0400

> [Ingo Molnar - Tue, Sep 15, 2009 at 08:36:47PM +0200]
> | 
> | not sure which merge caused this, but i got this boot crash with latest 
> | -git:
> | 
> | calling  flow_cache_init+0x0/0x1b9 @ 1
> | initcall flow_cache_init+0x0/0x1b9 returned 0 after 64 usecs
> | calling  pg_init+0x0/0x37c @ 1
> | pktgen 2.72: Packet Generator for packet performance testing.
> | ------------[ cut here ]------------
> | kernel BUG at net/core/pktgen.c:3503!
> | invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> | last sysfs file: 
> | 
> 
> Hi Ingo,
> 
> just curious, will the following patch fix the problem?
> I've been fixing problem with familiar symthoms on
> system with custome virtual cpu implementation so
> it may not help in mainline but anyway :)

Ingo, does Cyrill's patch help?
