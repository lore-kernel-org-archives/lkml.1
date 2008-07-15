Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYGONFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYGONFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbYGONFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:05:44 -0400
Received: from bu3sch.de ([62.75.166.246]:51415 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760961AbYGONFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:05:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH] Add SPI over GPIO driver
Date: Tue, 15 Jul 2008 15:05:16 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>, openwrt-devel@lists.openwrt.org
References: <200807142109.13243.mb@bu3sch.de> <1216099851.4265.156.camel@moss.renham>
In-Reply-To: <1216099851.4265.156.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151505.16371.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008 07:30:51 Ben Nizette wrote:
> Looks good overall.  I'm not sure that it need pretend to be
> hotpluggable though

Because the hardware _is_ hotpluggable.

> (i.e. the board info can be hardwired so there's no 
> need for the board setup callback).

I'm not sure why we should limit ourselves so much by compiling
dynamic and completely individual information, like the bus
wireing into the kernel.
This _has_ to be dynamic, as the wireing is _completely_ random and
different for every machine. This is selfmade hardware. ;)

> What problem are you solving (or whole in board support are you
> plugging) in this dynamic plugging of MMCs?

This is to support running MMCs/SDs on GPIO pins.
Which board or card provides the GPIO pins doesn't matter. It doesn't
matter, as it's completely abstracted. You can even run 10 or more
of the cards at the same time, if you have enough GPIO pins.

Of course, this is mostly useful for embedded systems only.
But it is not bound to any specific type of hardware. The hardware just
has to implement generic GPIO for its GPIO pins.

-- 
Greetings Michael.
