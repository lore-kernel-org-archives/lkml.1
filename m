Return-Path: <linux-kernel-owner+w=401wt.eu-S934878AbYBBUul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878AbYBBUul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761814AbYBBUu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:50:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60295 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761212AbYBBUu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:50:28 -0500
Message-ID: <47A4D791.3050700@garzik.org>
Date: Sat, 02 Feb 2008 15:50:25 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RFC] 3c509: convert to isa_driver and pnp_driver v2
References: <200801312012.43447.linux@rainbow-software.org> <200802021925.36552.linux@rainbow-software.org>
In-Reply-To: <200802021925.36552.linux@rainbow-software.org>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> Hello,
> this is second version of the patch. Autoloading using udev works fine with 
> PnP card. Hibernation now works both in PnP and ISA modes. The I/O address 
> used for non-pnp ISA card detection is now not released as it's needed to 
> wake up the card.
> 
> Manual irq and transceiver settings aren't implemented yet. Operation with 
> multiple cards is not tested - I'll try 3 cards in both PnP and ISA modes. 
> There is some code that is the same in each of the 4 probe functions (isa, 
> pnp, eisa and mca), which should be probably separated into a function.
> 
> I have no EISA or MCA machine so I hope that I didn't break them.

Looks pretty good at first glance...

I'll throw it in my queue.  Want to add a signed-off-by:  ?

	Jeff



