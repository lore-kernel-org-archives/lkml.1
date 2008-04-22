Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYDVHg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYDVHg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYDVHgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:36:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46566 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbYDVHgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:36:48 -0400
Date: Tue, 22 Apr 2008 08:36:22 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Linus' tree build breakage
Message-ID: <20080422073622.GB22955@flint.arm.linux.org.uk>
References: <20080422103111.e1d38371.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422103111.e1d38371.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 10:31:11AM +1000, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory
> 
> I have reverted commit 5dc3339aa5ba29593ea57814049ddca8c12831c8 ("[ARM]
> 4964/1: htc-pasic3: MFD driver for PASIC3 LED control + DS1WM chip") as
> the easiest thing.

That's known from the -mm tree since last week.  It's not the only thing
that's wrong.

I had asked Linus on Monday morning _not_ to pull my tree because there's
various problems with it.  Unfortunately, though Linus didn't see that
before he pulled it and I now have a rapidly growing set of fixes.

It will be towards the end of this week before I'll be able to finish
resolving the problems.

> Russell, this is why I would have liked you to participate in the
> linux-next tree ...

linux-next will not give me anything which -mm isn't giving me.  As I
said in the discussion, linux-next value is _very_ small for me.

Sorry but true.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
