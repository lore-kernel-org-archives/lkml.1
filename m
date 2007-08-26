Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXHZRms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXHZRms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 13:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbXHZRml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 13:42:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57703 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbXHZRmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 13:42:40 -0400
Date: Sun, 26 Aug 2007 19:42:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Fred Tyler <fredty8@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <466ad3f90708260958ha149c40ncf5a8287c8a25307@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708261940230.15614@fbirervta.pbzchgretzou.qr>
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com> 
 <466ad3f90708260851u5d8ac58duc4072b71ebf78fc8@mail.gmail.com> 
 <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr> 
 <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com> 
 <Pine.LNX.4.64.0708261828540.15614@fbirervta.pbzchgretzou.qr>
 <466ad3f90708260958ha149c40ncf5a8287c8a25307@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 12:58, Fred Tyler wrote:
>> So I guess you are not seeing any memory leak at all, but just the regular
>> caching?
>
>Also, how can you explain the differences between the graphs of
>long-term memory usage? This first graph is from a server running
>2.6.16 that never has memory problems:
>
>    http://i239.photobucket.com/albums/ff117/fredty8/memory-a4.png
>
>And here's a graph of a server running 2.6.12 that has to be rebooted
>every month or two because it runs out of memory:
>
>    http://i239.photobucket.com/albums/ff117/fredty8/memory-a2.png

Indeed that looks like a leak. But perhaps it would be helpful to not only
match MemFree Buffers and Cached (from /proc/meminfo) but also Slab.

>Now, admittedly, the 2.6.20 server has not been running long enough to
>know whether or not it's going to start starving applications of
>memory, but the graph here looks a whole lot more like 2.6.12 than
>2.6.16, wouldn't you agree:
>
>    http://i239.photobucket.com/albums/ff117/fredty8/memory-b1.png

But it looks like.

>Those 2.6.12 servers caused me a ton of stress because I let the
>problem go too long before I did anything. In the event that 2.6.20 is
>doing the same thing, I'm trying to fix it before things get out of
>control.
>

	Jan
-- 
