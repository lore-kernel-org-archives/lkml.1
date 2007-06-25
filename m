Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbXFYHIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbXFYHIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXFYHI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:08:27 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:33669 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599AbXFYHI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:08:26 -0400
In-Reply-To: <20070625050424.GZ943@1wt.eu>
References: <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm> <1182734240.26621.2.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm> <20070625050424.GZ943@1wt.eu>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <e6d26e7ee86cc527095de2716f285aff@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       david@lang.hm, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: -Os versus -O2
Date: Mon, 25 Jun 2007 09:08:23 +0200
To: Willy Tarreau <w@1wt.eu>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In my experience, -Os produced faster code on gcc-2.95 than -O2 or -O3.

On what CPU?  The effect of different optimisations varies
hugely between different CPUs (and architectures).

> It was not only because of cache considerations, but because gcc used
> different tricks to avoid poor optimizations, and at the end, the CPU
> ended executing the alternative code faster.

-Os is "as fast as you can without bloating the code size",
so that is the expected result for CPUs that don't need
special hand-holding around certain performance pitfalls.

> With gcc-3.3, -Os show roughly the same performance as -O2 for me on
> various programs. However, with gcc-3.4, I noticed a slow down with
> -Os. And with gcc-4, using -Os optimizes only for size, even if the
> output code is slow as hell. I've had programs whose speed dropped
> by 70% using -Os on gcc-4.

Well you better report those!  <http://gcc.gnu.org/bugzilla>

> But in some situtations, it's desirable to have the smallest possible
> kernel whatever its performance. This goes for installation CDs for
> instance.

There are much better ways to achieve that.


Segher

