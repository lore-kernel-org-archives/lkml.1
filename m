Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXBERIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXBERIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXBERIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:08:52 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2405 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbXBERIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:08:51 -0500
Date: Mon, 5 Feb 2007 17:08:23 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205170823.GF4563@flint.arm.linux.org.uk>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 08:58:10AM -0800, Linus Torvalds wrote:
> On Mon, 5 Feb 2007, Ingo Molnar wrote:
> > 
> > but this is /only/ practical if all (even disabled) features are visible 
> > (and selectable) in the tools. They are not at the moment, so selects 
> > are quite useful.
> 
> More importantly, some things that *are* visible probably shouldn't be, or 
> should perhaps only be in expert mode (aka "EMBEDDED").
> 
> A prime example of this is all the firewall settings. I'd personally 
> prefer to just select a "default firewall setup" which would be enough 
> for all the normal crud, instead of seeing 50 different choices. 

That also falls within my rule of "user visible symbols should not be
selected".

But... we already do something like this already and it doesn't take
a scattering of "select" to achieve.  Look at fs/partitions/Kconfig
as a good example.

You get offered "Advanced partition support" as the first question.
If you say "N", you get something reasonable for your platform.  If
you say "Y" you're free to choose whatever silly combination you
want, but with reasonable defaults offered.

That's something that a sprinking of select just can't do.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
