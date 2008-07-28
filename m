Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYG1WKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYG1WKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYG1WKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:10:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57279 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYG1WKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:10:46 -0400
Date: Mon, 28 Jul 2008 23:10:19 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Eric Miao <eric.miao@marvell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bad CONFIG variable references from Makefiles
Message-ID: <20080728221018.GB10072@flint.arm.linux.org.uk>
References: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain> <20080728215735.GI7713@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728215735.GI7713@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 12:57:36AM +0300, Adrian Bunk wrote:
> On Mon, Jul 28, 2008 at 04:09:28PM -0400, Robert P. J. Day wrote:
> > 
> >   a complete list of all references to non-existent CONFIG variables
> > exclusively from Makefiles in the tree.  since the list is so short,
> > i'm not bothering to break it up by subsystem or arch.  enjoy.
> >...
> > ===== CACHE_XSC3L2 =====
> > ./arch/arm/mm/Makefile:obj-$(CONFIG_CACHE_XSC3L2)	+= cache-xsc3l2.o
> >...
> 
> Comparing commit 20072fd0c93349e19527dd2fa9588b4335960e62
> ([ARM] pxa: add support for L2 outer cache on XScale3) with
> the patch that originally went to linux-arm-kernel it seems
> only a tiny fragment of the original patch arrived in the tree.

Very interesting.  It was applied using git-am from a mailbox sent to
me by Eric.  Strangly, the commit only contains the second file patched
by the contents of that message.

No idea how that happened.

Wonder how much other stuff has gone awry...

I'll strip out the second file from that message and reapply it.
Expect it to be fixed post-rc1 though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
