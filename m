Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYGHI6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYGHI6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYGHI6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:58:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39256
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbYGHI6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:58:38 -0400
Date: Tue, 08 Jul 2008 01:58:38 -0700 (PDT)
Message-Id: <20080708.015838.245133409.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: mchan@broadcom.com, dwmw2@infradead.org, bastian@waldi.eu.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080708073922.6c2470c1@the-village.bc.nu>
References: <20080707221950.3dfba435@the-village.bc.nu>
	<20080707.150549.242704515.davem@davemloft.net>
	<20080708073922.6c2470c1@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 8 Jul 2008 07:39:22 +0100

> > The firmware needs to be reloaded every time the chip resets.
> > You're not saving anything/
> 
> > See above, you aren't saving anything.  The firmware needs to stay
> > around so it can be reloaded into the card during exceptions.
> > 
> > That is, unless you want a more failure prone system.
> 
> Ok so if tg3 always needs the same firmware and always needs it in memory
> then maybe it isn't a significant candidate for request_firmware beyond
> the neatness of distribution. I note the firmware hasn't changed in years
> so it can easily be shipped separately and the one package would have
> done for all this time.

It isn't just tg3.  All the broadcom gigabit chips need this
kind of handling.

Basically all of the drivers we are pushing back on.

I bet there are other similar examples.

> > > Driver authors aren't God.
> > 
> > They (actually, more specifically the maintainers) to a certain extent
> > are, because they are the ones who eat doo-doo when something explodes.
> 
> So do the distributions and the users.

Not really. The dist folks and users hit a problem, and it rolls
downhill quickly, and more often than not it plops right on the head
of the driver maintainer.
