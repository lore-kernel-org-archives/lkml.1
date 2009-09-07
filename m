Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZIGPeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZIGPeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZIGPeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:34:21 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:60386 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbZIGPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:34:21 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 1FE9028B1C5
Message-ID: <4AA527FB.7020100@arcor.de>
Date: Mon, 07 Sep 2009 18:34:19 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frans Pop <elendil@planet.nl>, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and
   measurements
References: <20090906205952.GA6516@elte.hu> <200909070405.23936.elendil@planet.nl> <20090907121613.GA32097@elte.hu>
In-Reply-To: <20090907121613.GA32097@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2009 03:16 PM, Ingo Molnar wrote:
> [...]
> Note that usually we can extrapolate ballpark-figure quad and dual
> socket results from 8 core results. Trends as drastic as the ones
> i reported do not get reversed as one shrinks the number of cores.
>
> Con posted single-socket quad comparisons/graphs so to make it 100%
> apples to apples i re-tested with a single-socket (non-NUMA) quad as
> well, and have uploaded the new graphs/results to:
>
>    kernel build performance on quad:
>       http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild-quad.jpg
>
>    pipe performance on quad:
>       http://redhat.com/~mingo/misc/bfs-vs-tip-pipe-quad.jpg
>
>    messaging performance (hackbench) on quad:
>       http://redhat.com/~mingo/misc/bfs-vs-tip-messaging-quad.jpg
>
>    OLTP performance (postgresql + sysbench) on quad:
>       http://redhat.com/~mingo/misc/bfs-vs-tip-oltp-quad.jpg
>
> It shows similar curves and behavior to the 8-core results i posted
> - BFS is slower than mainline in virtually every measurement.

Except for numbers, what's your *experience* with BFS when it comes to 
composited desktops + games + multimedia apps?  (Watching high 
definition videos, playing some latest high-tech 3D game, etc.)  I 
described the exact problems experienced with mainline in a previous reply.

Are you even using that stuff actually?  Because it would be hard to 
tell if your desktop consists mainly of Emacs and an xterm; you even 
seem to be using Mutt so I suspect your desktop probably doesn't look 
very Windows Vista/OS X/Compiz-like.  Usually, with "multimedia desktop 
PC" one doesn't mean:

   http://foss.math.aegean.gr/~realnc/pics/desktop2.png

but rather:

   http://foss.math.aegean.gr/~realnc/pics/desktop1.png

BFS probably wouldn't offer the former anything, while on the latter it 
does make a difference.  If your usage of the "desktop" bears a 
resemblance to the first example, I'd say you might be not the most 
qualified person to judge on the "Linux desktop experience."  That is 
not meant be offensive or patronizing, just an observation and I even 
might be totally wrong about it.
