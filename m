Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbYD1Gke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbYD1Gke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbYD1Gk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:40:26 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53727 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbYD1GkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:40:25 -0400
Date: Mon, 28 Apr 2008 09:39:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig 'depend' vs. 'select'
Message-ID: <20080428063953.GA2088@cs181133002.pp.htv.fi>
References: <20080427.174536.62560212.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080427.174536.62560212.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 05:45:36PM -0700, David Miller wrote:
> 
> I'm trying to stir up interest in solving a problem that seems to pop
> up frequently. :)
> 
> The short story is:
> 
> 1) If you say your driver "depend"s on a subsystem providing a set of
>    interfaces you need, this doesn't work properly if your driver is
>    marked built-in and that subsystem you need is modular for some
>    reason.
>...

This should work.

Can you give an example of the problem you are thinking of?

> So if you had, for example:
> 
> config FOO_API
> 	...
> 
> and then you had two drivers:
> 
> config DRIVER1
> 	tristate ...
> 	needs FOO_API
> 
> config DRIVER2
> 	tristate ...
> 	needs FOO_API
> 
> and DRIVER1 was built modular but DRIVER2 was built-in,
> the Kconfig system would make sure FOO_API were built-in.
> 
> The "needs" name and syntax is just something arbitrary I came up
> with, don't take it too seriously :-)

What about "select"?

That's exactly what it's doing.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

