Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbYGGV65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbYGGV65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbYGGV6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:58:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55412
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758876AbYGGV6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:58:19 -0400
Date: Mon, 07 Jul 2008 14:58:19 -0700 (PDT)
Message-Id: <20080707.145819.209342070.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jeff@garzik.org, dwmw2@infradead.org, andi@firstfloor.org, tytso@mit.edu,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080707221427.163c4a30@the-village.bc.nu>
References: <20080707214218.055bcb35@the-village.bc.nu>
	<20080707.144505.67398603.davem@davemloft.net>
	<20080707221427.163c4a30@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 7 Jul 2008 22:14:27 +0100

> > > You seem to be trying to conflate legal and technical issues here.
> > 
> > Exactly like the patches we are current discussing.
> > 
> > Thanks for walking right into that. :-)
> 
> No - the patches are for technical reasons, 

Which are?  Consistent use of request_firmware()?

That's pure bullox as far as I can see.  Why provide the means to
do something nobody has had a need for in 6+ years?  Who needs
to load different firmware for the tg3 driver?

Who needs that capability? Distribution vendors?  What for?
In what case will they need to load different firmware from
what the driver maintainer tested as a unit?

Rather, they want separation.  I can see no other real impetus.

And, btw, who has the right to enforce this new burdon upon driver
maintainers when they have had a working and maintainable system for
so long?

I can only see it being about separation, pure and simple.
