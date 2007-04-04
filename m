Return-Path: <linux-kernel-owner+w=401wt.eu-S2992853AbXDDLQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992853AbXDDLQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992855AbXDDLQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:16:00 -0400
Received: from mx10.go2.pl ([193.17.41.74]:38026 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992853AbXDDLP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:15:59 -0400
Date: Wed, 4 Apr 2007 13:21:00 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Christian Kujau <christian@g-house.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
Message-ID: <20070404112100.GA1979@ff.dom.local>
References: <20070403065810.GA1832@ff.dom.local> <Pine.LNX.4.64.0704031618070.3963@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704031618070.3963@sheep.housecafe.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 04:19:46PM +0100, Christian Kujau wrote:
> On Tue, 3 Apr 2007, Jarek Poplawski wrote:
> >Did you try with 8139cp instead of 8139too?
> 
> Tried that, 8139cp could not be loaded :(

Sorry for misleading!

> >(Maybe even try some other card to narrow the problem?)
> >You could also try to test without ehci, if it's possible.
> 
> USB has been disabled completely. After booting with 'acpi=off lapic' 
> the box survived ~30min then locked up again and rebooted.

So, it's a lot sooner than before. (BTW, isn't there anything
in debug log?) I see both CPUs did interrupt handling again.
Maybe it's a real locking problem. Here are some more
suggestions for testing (if you don't find anything better):
- try without SMP, so: 'acpi=off lapic nosmp'
- lock debugging turned on as much as possible
plus maybe for curiosity:
- different CONFIG_HZ
- 8139TOO_PIO = y

...
> IRQ-problems with the Un-Interruptible-Power-Supply

I wouldn't be surprised... 

Cheers,
Jarek P.
