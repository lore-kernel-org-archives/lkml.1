Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbXFDU7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbXFDU7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbXFDU7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:59:09 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:53141 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbXFDU7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:59:07 -0400
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
From: Richard Purdie <rpurdie@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, akpm <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <4cefeab80706041126y5f12402cl61b72ec101dd7915@mail.gmail.com>
References: <1180971378.6313.72.camel@localhost.localdomain>
	 <200706041214.38017.dhazelton@enter.net>
	 <1180975976.6313.133.camel@localhost.localdomain>
	 <4cefeab80706041126y5f12402cl61b72ec101dd7915@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 21:58:51 +0100
Message-Id: <1180990731.6313.179.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 23:56 +0530, Nitin Gupta wrote:
> Yes there might still be problems - that is why I posted as RFC. I got
> useful comments and the code is improving. Going for such fork might
> be pain initially but IMHO its worth it. My idea for this 'fork' is
> not just clean-ups but potential optimizations that such cleanups
> usually bring along. I do not think there will be major overhauls in
> such mature de/compression implementations so I believe its okay to go
> for such 'fork' for sake of cleaner and perhaps faster code.

If you want to make cleaner and faster code, why not work on LZO
upstream directly? I'm sure the LZO author would welcome the speedups,
just as much as the kernel would. 

If they're accepted into LZO, I'm nearly certain the kernel will accept
them and if the kernel code is as I've proposed, upgrading is
straightforward too. Working with "upstream" is often harder but
ultimately much more rewarding.

> Again, I am working on improving the code as per feedback. This is
> what I expect from RFC. Many people raised concerns regarding
> bloatware in your patch too, including me.

And there are concerns against your patches including:

* endian issues
* alignment issues
* potential security holes
* unexplained code generation differences
* difficulty of upgrading

Compared to the style/bloat issue, I'd say that's a fair compromise.

Regards,

Richard

