Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZDURnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZDURnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZDURm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:42:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:33699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZDURmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:42:54 -0400
Subject: Re: Wait for console to become available, v3.2
From: David Woodhouse <dwmw2@infradead.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: David Brownell <david-b@pacbell.net>, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421172929.GC8251@cuplxvomd02.corp.sa.net>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net>
	 <20090421064346.GB8020@elte.hu> <200904210013.48551.david-b@pacbell.net>
	 <1240333871.3632.70.camel@macbook.infradead.org>
	 <20090421172929.GC8251@cuplxvomd02.corp.sa.net>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 18:41:05 +0100
Message-Id: <1240335665.3632.71.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 10:29 -0700, David VomLehn wrote:
> On Tue, Apr 21, 2009 at 06:11:11PM +0100, David Woodhouse wrote:
> ...
> > The kernel output is going to be spewed when a console registers with
> > CON_PRINTBUFFER anyway, and if we printk a warning about userspace
> > console output being lost, that ought to be good enough to notify the
> > user that something may have been lost. For bonus points, we could even
> > make that 'dummy' tty driver buffer a limited amount of userspace
> > output, maybe.
> 
> What in the world are users going to do when they see a message about
> output being lost? There is no way to recover the data and no way to
> prevent it in the future. I don't think this is a good approach.
> 
> Remember, even though the previous functionality of USB consoles was, in
> theory, less reliable than it appeared, it actually has been working well
> for years. Thus, tossing output will count as a regression for most of the
> world.

So implement a small amount of buffering, as I suggested, and it should
be sufficient to cover the cases that were only working before by blind
luck anyway.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

