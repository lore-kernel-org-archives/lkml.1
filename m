Return-Path: <linux-kernel-owner+w=401wt.eu-S936604AbXHHQdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936604AbXHHQdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934434AbXHHQdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:33:18 -0400
Received: from www.osadl.org ([213.239.205.134]:39058 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936345AbXHHQdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:33:16 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Greg KH <gregkh@suse.de>
Subject: Re: [rfc] Re: [PATCH] Make UIO available for arm architecture
Date: Wed, 8 Aug 2007 18:33:12 +0200
User-Agent: KMail/1.9.5
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <200708081808.13889.hjk@linutronix.de> <Pine.LNX.4.64.0708081812250.3715@fbirervta.pbzchgretzou.qr> <20070808161002.GA11153@suse.de>
In-Reply-To: <20070808161002.GA11153@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081833.12459.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 08 August 2007 18:10 schrieb Greg KH:
> On Wed, Aug 08, 2007 at 06:15:21PM +0200, Jan Engelhardt wrote:
> > 
> > On Aug 8 2007 18:08, Hans-J??rgen Koch wrote:
> > >---
> > >Index: linux-2.6.23-rc/arch/arm/Kconfig
> > >===================================================================
> > >--- linux-2.6.23-rc.orig/arch/arm/Kconfig	2007-08-08 17:52:02.000000000 +0200
> > >+++ linux-2.6.23-rc/arch/arm/Kconfig	2007-08-08 17:53:29.000000000 +0200
> > >@@ -1052,6 +1052,8 @@
> > > 
> > > source "drivers/dma/Kconfig"
> > > 
> > >+source "drivers/uio/Kconfig"
> > >+
> > > endmenu
> > > 
> > > source "fs/Kconfig"
> > 
> > I am raising a general question here.
> > Should not such cross-platform things be made available in a general
> > Kconfig rather than having to patch each arch's Kconfig?
> > 
> > I am thinking of drivers/Kconfig for this one (of course I am aware that this
> > requires an extra "depends on X86 || SPARC || others" in drivers/pci/Kconfig),
> > and perhaps even a top-level Kconfig for things like truly arch-independent
> > fs/Kconfig.
> 
> Um, uio _is_ in drivers/Kconfig already :)

Of course :-)

> 
> But I'm guessing that ARM doesn't use that file yet?  

No, they don't. They source Kconfigs from each drivers subdirectory.

> If so, I have no 
> objection to the above patch, but it should go through the ARM
> developers, not me.

OK, as I've CCed linux-arm-kernel, I hope Russell will do that.

Thanks,
Hans
