Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZCFQod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZCFQod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbZCFQoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:44:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:35057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbZCFQoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:44:24 -0500
Date: Fri, 6 Mar 2009 08:42:27 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       phil@hannent.co.uk, mwilder@cs.nmsu.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: build issue #591 for v2.6.29-rc7-3-g559595a
	:drivers/staging/mimio/mimio.ko
Message-ID: <20090306164227.GA24492@suse.de>
References: <200903060928.24462.toralf.foerster@gmx.de> <49B1517C.7000809@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49B1517C.7000809@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 08:38:20AM -0800, Randy Dunlap wrote:
> Toralf Förster wrote:
> > Hello,
> > 
> > the build (.config attached) failed, make ends with :
> > ...
> >   CC      arch/x86/boot/video-bios.o
> >   LD      arch/x86/boot/setup.elf
> >   OBJCOPY arch/x86/boot/setup.bin
> >   OBJCOPY arch/x86/boot/vmlinux.bin
> >   HOSTCC  arch/x86/boot/tools/build
> >   BUILD   arch/x86/boot/bzImage
> > Root device is (3, 8)
> > Setup is 22056 bytes (padded to 22528 bytes).
> > System is 3078 kB
> > CRC b46a0cef
> > Kernel: arch/x86/boot/bzImage is ready  (#6)
> >   Building modules, stage 2.
> >   MODPOST 327 modules
> > ERROR: "input_register_device" [drivers/staging/mimio/mimio.ko] undefined!
> > ERROR: "input_allocate_device" [drivers/staging/mimio/mimio.ko] undefined!
> > ERROR: "input_event" [drivers/staging/mimio/mimio.ko] undefined!
> > ERROR: "input_close_device" [drivers/staging/mimio/mimio.ko] undefined!
> > ERROR: "input_free_device" [drivers/staging/mimio/mimio.ko] undefined!
> > ERROR: "input_unregister_device" [drivers/staging/mimio/mimio.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> > 
> > The build was made with :
> > $>make randconfig; make clean; make
> > 
> > Here's the config:
> 
> [snip]
> 
> I posted a patch for this on Feb. 20.
> Where is it, Greg?  (yes, you were cc-ed on it)

It's in my queue, sorry, have been traveling this week :(

thanks,

greg k-h
