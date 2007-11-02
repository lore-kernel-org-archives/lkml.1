Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbXKBUIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbXKBUIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 16:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXKBUIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 16:08:48 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49651 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbXKBUIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 16:08:47 -0400
Date: Fri, 2 Nov 2007 21:10:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] : kernel/built-in.o(.text+0x18db4):kernel/workqueue.c:823: undefined reference to `.L343'
Message-ID: <20071102201023.GA16670@uranus.ravnborg.org>
References: <20071102202931.deb09211.Kristoffer.ericson@gmail.com> <20071102194818.GA22719@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102194818.GA22719@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 07:48:18PM +0000, Russell King - ARM Linux wrote:
> On Fri, Nov 02, 2007 at 08:29:31PM -0700, Kristoffer Ericson wrote:
> > Greetings,
> > 
> > Haven't found anyone reporting this. Taken from the very latest linux-2.6.git pull.
> > 
> > dnsdomainname: Unknown host
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > kernel/built-in.o(.text+0x18db0): In function `destroy_workqueue':
> > kernel/workqueue.c:823: undefined reference to `.L342'
> > kernel/built-in.o(.text+0x18db4):kernel/workqueue.c:823: undefined reference to `.L343'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> I think you'll have to look at the assembly produced for workqueue.c and
> work out why GCC is referencing an undefined label.  You can get the
> assembly for that by doing:
> 
> make ARCH=arm ...etc... kernel/workqueue.s
Or make that:

make ARCH=arm ...etc... kernel/workqueue.lst

to get intermixed C and assenbly

	Sam
