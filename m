Return-Path: <linux-kernel-owner+w=401wt.eu-S1751125AbXA0KLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbXA0KLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 05:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbXA0KLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 05:11:21 -0500
Received: from nic2.axis.se ([193.13.178.10]:36641 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbXA0KLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 05:11:20 -0500
Date: Sat, 27 Jan 2007 11:11:03 +0100
Message-Id: <200701271011.l0RAB3MD018814@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: david-b@pacbell.net
CC: hans-peter.nilsson@axis.com, linux-kernel@vger.kernel.org,
       mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net
In-reply-to: <200701261521.15844.david-b@pacbell.net> (message from David
	Brownell on Fri, 26 Jan 2007 15:21:15 -0800)
Subject: Re: [PATCH 1/2] take 2: (was-kind-of: 3/5 SPI tx_default) 2.6.20-rc6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Brownell <david-b@pacbell.net>
> Date: Fri, 26 Jan 2007 15:21:15 -0800

> > >  That flag could work in conjunction with a byte
> > 
> > Or why not a 32-bit word!
> 
> If a driver wants a repeating 32-bit pattern, they should just
> provide a properly initialized tx buffer.

I'm suggesting the default_tx_word be able to fill out "common"
values of bits_per_word when > 8, else it'd be useless as a
1-filler for larger sizes than byte.  Making it a single bit
then wouldn't cater to your debug-with-scope use-case.

brgds, H-P
