Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbXFVUpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbXFVUpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXFVUpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:45:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2826 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751990AbXFVUpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:45:24 -0400
Date: Fri, 22 Jun 2007 08:58:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Jiri Kosina <jikos@jikos.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] blink: Only blink when parameter is set
Message-ID: <20070622085837.GA6924@ucw.cz>
References: <20070617083904.GC4496@suse.de> <20070621002034.GA18143@elf.ucw.cz> <Pine.LNX.4.64.0706210222390.3068@twin.jikos.cz> <200706202256.53850.dtor@insightbb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706202256.53850.dtor@insightbb.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > In fact it looks quite weird that one blink per 5 seconds can break the 
> > keyboard, in fact.
> 
> Not wierd at all. The driver uses panic_blink - something that we expect
> to work after panic. It rapidly polls KBC status register to detect when

Aha. Can we get rid of that driver? It is so broken it is not funny.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
