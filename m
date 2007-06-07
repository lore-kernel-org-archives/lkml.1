Return-Path: <linux-kernel-owner+w=401wt.eu-S936445AbXFGUqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936445AbXFGUqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760498AbXFGUqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:46:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34059 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbXFGUqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:46:05 -0400
Date: Thu, 7 Jun 2007 22:47:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tom <fivemiletom@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RE : Building kernel 2.6.21.3 for arm on cygwin
Message-ID: <20070607204707.GB16634@uranus.ravnborg.org>
References: <4660971E.5020609@gmail.com> <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan> <46645DC9.8080003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46645DC9.8080003@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:45:29AM -0700, Tom wrote:
> Hi Sam
> 
> 
> enclosed is the 'k_smf.patch' which modifies three files to enable the 
> kernel 2.6.21.3 to be built under cygwin:
> host:  cygwin 1.5.24, hostcc= gcc 3.4.4
> cross: arm-linux-uclibcgnueabi-gcc (GCC) 4.1.2
> cmd:   make ARCH=arm CROSS_COMPILE=arm-linux- \
>        HOST_LOADLIBES="-lcurses -lintl" at91rm9200dk_defconfig
> 
> I verified that this does not break building on a linux-host on this config:
> host:  FC5, gcc 4.1.1-1
> cross: arm-none-linux-gnueabi-gcc 4.1.1
> cmd:   make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi-
> 
> 
> Let me know if I can help any further.
Hi Tom.

Patch looks good. The last bit touching sumversion.c is not
needed in latest kernel - we already include limits.h.

I need you to sign off the patch as per instruction in
Documentation/SubmittingPatch.
Please do so and send me a new mail containing both
changlog entry (the introduction part of your mail) and
the patch itself.

	Sam
