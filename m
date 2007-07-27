Return-Path: <linux-kernel-owner+w=401wt.eu-S935509AbXG0Ngd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935509AbXG0Ngd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761909AbXG0NgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:36:05 -0400
Received: from sandeen.net ([209.173.210.139]:10953 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758481AbXG0NgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:36:00 -0400
Message-ID: <46A9ECD5.3050801@sandeen.net>
Date: Fri, 27 Jul 2007 08:02:13 -0500
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
References: <469BF104.1040703@gmail.com>	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>	<469BF768.6040200@gmail.com>	<20070716230719.GC11115@waste.org>	<469BFB73.3070105@gmail.com>	<20070716232755.GD11115@waste.org>	<20070719001539.GC29728@v2.random>	<20070719013955.1bedc423@the-village.bc.nu>	<20070719013358.GD29728@v2.random>	<20070719013725.GP11115@waste.org>	<20070719112436.GG29728@v2.random> <20070719124419.48c3d610@the-village.bc.nu>
In-Reply-To: <20070719124419.48c3d610@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I don't think they're necessarily bugs. IMHO the WARN_ON is better off
>> at 7k level like it is today with the current STACK_WARN. 4k for a
>> stack for common code really is small. I doubt you're going to find
> 
> You want the limit settable. On a production system you want to set the
> limit to somewhere appropriate for the stack size used. When debugging
> (eg to remove any last few bogus users of 8K stack space) you want to be
> able to set it to just under 4K

Hm, when cramming cxfs into 4k at sgi, I had a patch that did just that
for debugging (warn about encroaching on 4k without actually tipping
over, with a settable threshold...)

Maybe I should resurrect it & send it out...

(FWIW I think I recall that the warning itself sometimes tipped the
scales enough on 4k stacks to bring the box down)

-eric
