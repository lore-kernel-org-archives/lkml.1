Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbXGSB61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbXGSB61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXGSB6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:58:17 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45222 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXGSB6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:58:17 -0400
Message-ID: <469EC4E7.3060007@gmail.com>
Date: Thu, 19 Jul 2007 03:56:55 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrea Arcangeli <andrea@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org> <20070719001539.GC29728@v2.random> <20070719013955.1bedc423@the-village.bc.nu> <20070719013358.GD29728@v2.random> <20070719013725.GP11115@waste.org>
In-Reply-To: <20070719013725.GP11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2007 03:37 AM, Matt Mackall wrote:

> Here's a way to make forward progress on this whole thing:
> 
> Turn on irqstacks when using 8k stacks

WLI: are you submitting? Makes great sense regardless of anything and 
they've been tested silly with 4KSTACKS already...

> Detect when usage with 8k stacks would overrun a 4k stack when doing
> our stack switch and do a WARN_ONCE

Our stack switch?

> Fix up the damn bugs

DM ofcourse is fairly "layered-by-design" so I _hope_ they can be classified 
simple bugs...

Rene.
