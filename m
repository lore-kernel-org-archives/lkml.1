Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0BSUEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:04:39 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43691 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753183Ab0BSUEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:04:37 -0500
X-Greylist: delayed 1693 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Feb 2010 15:04:37 EST
Date: Thu, 18 Feb 2010 23:57:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, kernel list <linux-kernel@vger.kernel.org>,
       Segher Boessenkool <segher@kernel.crashing.org>, bergner@vnet.ibm.com
Subject: Re: register long sp asm("r1") incorrect
Message-ID: <20100218225711.GA1386@ucw.cz>
References: <20100209152444.GA30176@atrey.karlin.mff.cuni.cz> <1265866273.16346.34.camel@pasglop> <20100215073405.GB20456@atrey.karlin.mff.cuni.cz> <1266263992.16346.125.camel@pasglop> <20100215202854.GA21601@elf.ucw.cz> <1266267898.16346.135.camel@pasglop> <4B79C775.1050903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B79C775.1050903@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-02-15 14:15:17, H. Peter Anvin wrote:
> On 02/15/2010 01:04 PM, Benjamin Herrenschmidt wrote:
> > 
> > It's true that most other use of it we have are global scope (local_paca
> > in r13, glibc use of r2/r13, etc...) afaik, but since r1 itself is the
> > stack pointer always, I think they pretty much guarantee it works.
> > 
> 
> It should work, because r1, being the stack pointer, is already marked a
> reserved register in gcc.
> 
> The reference Pavel is citing bascially states that gcc won't globally
> reserve the register, which is true, but it is already reserved anyway.

Ok, thanks for clarification.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
