Return-Path: <linux-kernel-owner+w=401wt.eu-S934376AbXG0NgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376AbXG0NgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760367AbXG0NgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:36:04 -0400
Received: from sandeen.net ([209.173.210.139]:10950 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbXG0NgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:36:00 -0400
X-Greylist: delayed 2024 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 09:36:00 EDT
Message-ID: <46A9ED28.3070508@sandeen.net>
Date: Fri, 27 Jul 2007 08:03:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.5 (Macintosh/20070716)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrea Arcangeli <andrea@suse.de>, Matt Mackall <mpm@selenic.com>,
       Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8GVjY-PL-25@gated-at.bofh.it>	<E1IA7j1-0000j9-I3@be1.lrz>	<469A5D7C.5010904@gmail.com>	<Pine.LNX.4.58.0707161523500.25779@be1.lrz>	<469BF104.1040703@gmail.com>	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>	<469BF768.6040200@gmail.com>	<20070716230719.GC11115@waste.org>	<469BFB73.3070105@gmail.com>	<20070716232755.GD11115@waste.org>	<20070719001539.GC29728@v2.random> <20070719013955.1bedc423@the-village.bc.nu>
In-Reply-To: <20070719013955.1bedc423@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> About 4k stacks I was generally against them, much better to fail in
>> fork than to risk corruption. The per-irq stack part is great feature
>> instead (too bad it wasn't enabled for the safer 8k stacks).
> 
> 8K stacks without IRQ stacks are not "safer" so I don't understand your
> comment ?

Hmm was it SuSE or RH kernels (or mainline?) I saw which had a test to
defer soft IRQs if they occurred too deep in the stack for the current
thread.

-Eric
