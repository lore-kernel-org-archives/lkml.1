Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZDVVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZDVVYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZDVVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:24:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49056 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752176AbZDVVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:24:19 -0400
Date: Wed, 22 Apr 2009 17:24:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David VomLehn <dvomlehn@cisco.com>, Jamie Lokier <jamie@shareable.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <20090422220853.0af12ece@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0904221723010.23158-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Alan Cox wrote:

> > 2.	All devices have been probed
> > If we exit for reason 2, it means that no such device is present,
> > and we go on to the do the appropriate thing for that device class.
> 
> USB has no notion of #2 really

That's true, it doesn't.  But it _does_ rather have a notion of "all 
devices that were present at boot time have been probed".  That should 
be good enough.

Alan Stern

