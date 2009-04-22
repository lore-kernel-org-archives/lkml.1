Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZDVI0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZDVI0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZDVI00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:26:26 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48025 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZDVI0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:26:25 -0400
Date: Wed, 22 Apr 2009 09:25:47 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <david-b@pacbell.net>, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, David VomLehn <dvomlehn@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090422082547.GB31246@shareable.org>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <200904210013.48551.david-b@pacbell.net> <1240333871.3632.70.camel@macbook.infradead.org> <alpine.LFD.2.00.0904211016190.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904211016190.2199@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> [ Actually, looking closer we should not use that particular name: we 
>   already have something called a "console_driver" which is really the 
>   "current VT" driver.

Speaking of names... The word "console" is used to mean three
different things in the kernel.  Last time I had to understand the
console code (because it wasn't showing on some device) that didn't
help.  But it was a 2.4 kernel 2 years ago so I didn't submit a patch :-)

It would be a sensible though boring cleanup to change all the "VC"
(virtual console) stuff to use the name "VT" (virtual terminal)
consistently.

-- Jamie
