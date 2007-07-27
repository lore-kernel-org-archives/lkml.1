Return-Path: <linux-kernel-owner+w=401wt.eu-S937515AbXG0RS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937515AbXG0RS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764737AbXG0RSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:18:22 -0400
Received: from khc.piap.pl ([195.187.100.11]:36471 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764928AbXG0RSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:18:21 -0400
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrea Arcangeli <andrea@suse.de>,
       Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz>
	<469A5D7C.5010904@gmail.com>
	<Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	<469BF104.1040703@gmail.com>
	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	<469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org>
	<469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org>
	<20070719001539.GC29728@v2.random>
	<20070719013955.1bedc423@the-village.bc.nu>
	<46A9ED28.3070508@sandeen.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 27 Jul 2007 19:18:18 +0200
In-Reply-To: <46A9ED28.3070508@sandeen.net> (Eric Sandeen's message of "Fri, 27 Jul 2007 08:03:36 -0500")
Message-ID: <m3vec54vfp.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@sandeen.net> writes:

>> 8K stacks without IRQ stacks are not "safer" so I don't understand your
>> comment ?
>
> Hmm was it SuSE or RH kernels (or mainline?) I saw which had a test to
> defer soft IRQs if they occurred too deep in the stack for the current
> thread.

Perhaps the "8 KB softpage" should be an option instead
of 8 KB stack size?

Not sure about ABI compatibility.
-- 
Krzysztof Halasa
