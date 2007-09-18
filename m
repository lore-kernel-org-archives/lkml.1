Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbXIRTXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbXIRTXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbXIRTXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:23:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938AbXIRTXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:23:08 -0400
Date: Tue, 18 Sep 2007 12:22:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
In-Reply-To: <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com> 
 <20070918113401.6a8a737f@the-village.bc.nu> 
 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com> 
 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> 
> ACK -- driver developers use this just to save themselves a few lines
> from calling pci_resource_start() and friends. How about having an
> inline which does what pci_iomap() does except it doesn't call
> ioport_map() ? I am just not sure where this would go..

I'm not understanding what the problem is?

Why don't these people just use "ioread*()/iowrite*()"? 

In other words, the whole point of *not* using "read*/write*()" is that 
you get a whole slew of much nicer interfaces.

So can people explain this fundamental issue? Why do people insist on 
using the old interfaces (and matching them with the new setup)?

			Linus
