Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbYGKOQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbYGKOQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYGKOQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:16:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50258 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752106AbYGKOQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:16:27 -0400
Date: Fri, 11 Jul 2008 10:16:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
In-Reply-To: <200807110903.48500.arvidjaar@mail.ru>
Message-ID: <Pine.LNX.4.44L0.0807111013060.2515-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[If nobody minds, after this message I will remove everything except 
linux-usb from the CC: list.]

On Fri, 11 Jul 2008, Andrey Borzenkov wrote:

> On Sunday 06 July 2008, Alan Stern wrote:
> > There doesn't seem to be much choice.
> > 
> > As I recall, the consequences of leaving the old code were that 
> > sometimes a suspend or a resume wouldn't work as expected.  That's 
> > better than hanging the entire system -- but on the other hand, it 
> > would affect more people.
> > 
> > Andrey, when you have time I'd like to do some more debugging to find 
> > out exactly what's going wrong.
> >
> 
> Let me know what you need. I am still running rc8 but may update if needed.

That's good; it'll help initially to test a system with the bug 
present.

To start with, add a printk near the start of ohci_irq() in ohci-hcd.c.  
Have it display in hex the value of "ints", immediately after the 
ohci_readl() call.

Alan Stern

