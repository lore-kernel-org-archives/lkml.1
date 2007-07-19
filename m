Return-Path: <linux-kernel-owner+w=401wt.eu-S1765831AbXGSKwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765831AbXGSKwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759619AbXGSKwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:52:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552AbXGSKwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:52:36 -0400
Date: Thu, 19 Jul 2007 12:52:32 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070719105232.GF29728@v2.random>
References: <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org> <20070719001539.GC29728@v2.random> <20070719013955.1bedc423@the-village.bc.nu> <20070719013358.GD29728@v2.random> <20070719102359.0e6a2e17@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719102359.0e6a2e17@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 10:23:59AM +0100, Alan Cox wrote:
> Still don't follow. How is "exceeds stack space but less likely to be
> noticed" safer.

Statistically speaking it clearly is. The reason is probably that the
irq theoretical issue happens only on large boxes with lots of
reentrant irqs. Not all irqs are reentrant, not all systems runs lots
of irqs at the same time etc..
