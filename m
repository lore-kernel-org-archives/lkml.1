Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbZDVJOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZDVJOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbZDVJOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:14:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41859 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755870AbZDVJOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:14:22 -0400
Date: Wed, 22 Apr 2009 10:13:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       David VomLehn <dvomlehn@cisco.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090422101303.406eef99@lxorguk.ukuu.org.uk>
In-Reply-To: <20090422082216.GA31246@shareable.org>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
	<20090421064346.GB8020@elte.hu>
	<20090421063549.3b71881d@infradead.org>
	<20090421135034.GA30114@elte.hu>
	<20090421140533.GA6375@shareable.org>
	<20090421142627.GA18129@elte.hu>
	<20090421153745.2d8964c7@lxorguk.ukuu.org.uk>
	<20090422082216.GA31246@shareable.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, that doesn't work, when you want to use the USB serial console
> _if_ there's a USB serial adapter plugged in, and a different (lower
> priority) console if it's not.

I don't see the problem. If there is a lower priority console available
then the kernel can use that anyway and clearly that would be the right
thing to do.

The case that wouldn't work perhaps is the 'no console present and a USB
or firewire one might appear' - for that to work you'd need the queue to
be smarter - or even the lowest priority console...

Alan
