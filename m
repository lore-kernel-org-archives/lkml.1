Return-Path: <linux-kernel-owner+w=401wt.eu-S1767476AbXCIUYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767476AbXCIUYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767485AbXCIUYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:24:19 -0500
Received: from mail13.syd.optusnet.com.au ([211.29.132.194]:53153 "EHLO
	mail13.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767476AbXCIUYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:24:18 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Mark Lord <liml@rtr.ca>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 07:23:51 +1100
User-Agent: KMail/1.9.5
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <87irdasnz4.fsf@depni.sinp.msu.ru> <45F1A263.5020407@rtr.ca>
In-Reply-To: <45F1A263.5020407@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100723.51858.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 05:07, Mark Lord wrote:
> Mmm.. when it's good, it's *really* good.
> My desktop feels snappier and all of that.
>
> No noticeable jerkiness of windows/scrolling,
> which I *do* observe with the stock scheduler.

Thats good.

> But when it's bad, it stinks.
> Like when a "make -j2" kernel rebuild is happening in a background window

And that's bad. When you say "it stinks" is it more than 3 times slower? It 
should be precisely 3 times slower under that load (although low cpu using 
things like audio wont be affected by running 3 times slower). If it feels 
like much more than that much slower, there is a bug there somewhere. As 
another reader suggested, how does it run with the compile 'niced'? How does 
it perform with make (without a -j number).

> This is on a Pentium-M 760 single-core, w/2GB SDRAM (notebook).

What HZ are you running? Are you running a Beryl desktop?

> JADP (Just Another Data Point).

Appreciated, thanks.

> Mark

-- 
-ck
