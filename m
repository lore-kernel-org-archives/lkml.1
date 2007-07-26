Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbXGZRc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbXGZRc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbXGZRbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:31:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:57331 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976AbXGZRbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:31:36 -0400
Date: Thu, 26 Jul 2007 21:21:18 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
Message-ID: <20070726212118.7fe7abd3@localhost.localdomain>
In-Reply-To: <46A79AA1.3030608@freescale.com>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
	<20070725165326.5331.19920.stgit@localhost.localdomain>
	<46A78322.3080607@ru.mvista.com>
	<46A78E3F.1030904@ru.mvista.com>
	<20070725180145.GA29689@ld0162-tx32.am.freescale.net>
	<46A7968D.3070707@ru.mvista.com>
	<46A79AA1.3030608@freescale.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 13:46:57 -0500
Scott Wood wrote:

> Sergei Shtylyov wrote:
> >    I acn undertand your complaint in the context of an OF driver
> > (which we don't have yet) but "mmio-ide" just means nothing to the
> > current driver, and it doesn't convery enough info on the
> > programming interface for the conceivable OF driver, it also does
> > need to know at least "reg-stride" (and maybe "reg-size" in case
> > only 16/32-bit accesses can be used).  Well, if such driver will be
> > written, I/O mapping support will probably be dropped from it, so
> > indeed, calling it mmio-ide.c would make sense.  But that can be
> > added when this driver is done, and for now 
> 
> I don't think the details of what Linux code currently exists should 
> drive the device tree binding.  That the current patches use 
> platform_device glue code is an implementation detail (and one I'd 
> rather see go away, in favor of a driver that supports both 
> platform_device and of_device).
> 
> > I'd really prefer the board name to appear in the "compatible" prop
> > (to which "mmio-ide" can be appended)...
> 
> Sure, that's always good...  it was the "instead" that I objected to.
> 

Hmmm. So what is finally suggested devicetree node for this beast - can somebody refine?

I am a little bit confused about decided device_type and compatible fields...

-- 
Sincerely, Vitaly
