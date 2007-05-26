Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXEZG5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXEZG5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 02:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbXEZG5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 02:57:37 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57220 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbXEZG5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 02:57:37 -0400
Date: Sat, 26 May 2007 08:58:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tej Parkash <tejparkash.d@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: reg: modules make in Ubuntu
Message-ID: <20070526065835.GA22020@uranus.ravnborg.org>
References: <2bd9ebfa0705252228u65b62ddbta2337ce56e77618a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bd9ebfa0705252228u65b62ddbta2337ce56e77618a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 01:28:56AM -0400, Tej Parkash wrote:
> make[1]: Entering directory `/usr/src/linux-headers-2.6.20-15-generic'
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
> make[2]: *** No rule to make target `arch/i386/kernel/msr.c', needed
> by `arch/i386/kernel/msr.o'.  Stop.
> make[1]: *** [arch/i386/kernel] Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.20-15-generic'
> make: *** [all] Error 2
> 
> what the hack is this. no kernel version is having this file in this
> particular location as asked in error. then why this error is coming
> in this kernel version.
Looks like you are trying to build a kernel but have only headers
judging from the directoryname.

Could you please prove a bit more context if you need additional help.
Like (but not limited to):
-> Actual commandline
-> Any own kbuild/Makefiles
-> .config

	Sam
