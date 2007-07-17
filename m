Return-Path: <linux-kernel-owner+w=401wt.eu-S1763572AbXGQRAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763572AbXGQRAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbXGQQ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:59:54 -0400
Received: from holomorphy.com ([66.93.40.71]:59370 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbXGQQ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:59:53 -0400
Date: Tue, 17 Jul 2007 10:01:27 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ray Lee <ray-lk@madrabbit.org>, Rene Herman <rene.herman@gmail.com>,
       Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Chinner <dgc@sgi.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070717170127.GJ11781@holomorphy.com>
References: <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <20070716235438.1bdd0722@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716235438.1bdd0722@the-village.bc.nu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At some point in the past, I wrote:
>> If at some point one of the pro-4k stacks crowd can prove that all
>> code paths are safe, or introduce another viable alternative (such as
>> Matt's idea for extending the stack dynamically), then removing the 8k
>> stacks option makes sense.

On Mon, Jul 16, 2007 at 11:54:38PM +0100, Alan Cox wrote:
> Any x86-32 path unsafe with 4K stacks is almost certainly unsafe with 8K
> stacks because the 8K stacks do not have seperate IRQ stack paths, so you
> have the same space but split. It might be less predictable on 8K stacks
> but it isn't absent.

At hch's suggestion I rewrote the separate IRQ stack configurability
patch into one making IRQ stacks mandatory and unconfigurable, and
hence enabled with 8K stacks.


-- wli
