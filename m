Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbZDVKku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbZDVKku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZDVKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:40:37 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56627 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZDVKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:40:36 -0400
Date: Wed, 22 Apr 2009 11:39:53 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       David Brownell <david-b@pacbell.net>, Ingo Molnar <mingo@elte.hu>,
       David VomLehn <dvomlehn@cisco.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090422103953.GB2196@shareable.org>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <200904210013.48551.david-b@pacbell.net> <1240333871.3632.70.camel@macbook.infradead.org> <alpine.LFD.2.00.0904211016190.2199@localhost.localdomain> <20090422082547.GB31246@shareable.org> <20090422101109.7beee3ee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422101109.7beee3ee@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > It would be a sensible though boring cleanup to change all the "VC"
> > (virtual console) stuff to use the name "VT" (virtual terminal)
> > consistently.
> 
> Then we would have two completely different meanings for virtual terminal
> in the kernel.

As opposed to three meanings for console - causing a bit of confusion
you had to point out to Linus earlier :-)

-- Jamie
