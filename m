Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbXGWEJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbXGWEJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 00:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbXGWEJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 00:09:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44698 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXGWEJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 00:09:15 -0400
Date: Sun, 22 Jul 2007 21:11:30 -0700
From: Greg KH <greg@kroah.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linus 2.6.23-rc1
Message-ID: <20070723041130.GA21455@kroah.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723012317.GA17181@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723012317.GA17181@linux-sh.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 10:23:17AM +0900, Paul Mundt wrote:
> On Sun, Jul 22, 2007 at 02:04:24PM -0700, Linus Torvalds wrote:
> > Lots of architecture updates (for just about all of them - x86[-64], arm, 
> > alpha, mips, ia64, powerpc, s390, sh, sparc, um..), lots of driver updates 
> > (again, all over - usb, net, dvb, ide, sata, scsi, isdn, infiniband, 
> > firewire, i2c, you name it).
> > 
> Some of the driver model changes that went in result in a link error:
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `store_uevent':
> : undefined reference to `kobject_actions'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Haven't bisected it yet, but I suppose it's pretty obvious to whoever
> made the changes. ;-)

Yes, the patch is on the list (and been pointed out already) and is in
my queue to send to Linus in the next few days.

thanks,

greg k-h
