Return-Path: <linux-kernel-owner+w=401wt.eu-S936205AbXHHQ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936205AbXHHQ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936263AbXHHQZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:25:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936212AbXHHQZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:25:58 -0400
Date: Wed, 8 Aug 2007 09:10:02 -0700
From: Greg KH <gregkh@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Hans-J?rgen Koch <hjk@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [rfc] Re: [PATCH] Make UIO available for arm architecture
Message-ID: <20070808161002.GA11153@suse.de>
References: <200708081808.13889.hjk@linutronix.de> <Pine.LNX.4.64.0708081812250.3715@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708081812250.3715@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 06:15:21PM +0200, Jan Engelhardt wrote:
> 
> On Aug 8 2007 18:08, Hans-J??rgen Koch wrote:
> >---
> >Index: linux-2.6.23-rc/arch/arm/Kconfig
> >===================================================================
> >--- linux-2.6.23-rc.orig/arch/arm/Kconfig	2007-08-08 17:52:02.000000000 +0200
> >+++ linux-2.6.23-rc/arch/arm/Kconfig	2007-08-08 17:53:29.000000000 +0200
> >@@ -1052,6 +1052,8 @@
> > 
> > source "drivers/dma/Kconfig"
> > 
> >+source "drivers/uio/Kconfig"
> >+
> > endmenu
> > 
> > source "fs/Kconfig"
> 
> I am raising a general question here.
> Should not such cross-platform things be made available in a general
> Kconfig rather than having to patch each arch's Kconfig?
> 
> I am thinking of drivers/Kconfig for this one (of course I am aware that this
> requires an extra "depends on X86 || SPARC || others" in drivers/pci/Kconfig),
> and perhaps even a top-level Kconfig for things like truly arch-independent
> fs/Kconfig.

Um, uio _is_ in drivers/Kconfig already :)

But I'm guessing that ARM doesn't use that file yet?  If so, I have no
objection to the above patch, but it should go through the ARM
developers, not me.

thanks,

greg k-h
