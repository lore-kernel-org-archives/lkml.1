Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYJXLkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYJXLkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYJXLkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:40:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbYJXLkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:40:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: Linux 2.6.28-rc1
Date: Fri, 24 Oct 2008 13:45:04 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <200810241224.38541.alistair@devzero.co.uk>
In-Reply-To: <200810241224.38541.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241345.04966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 of October 2008, Alistair John Strachan wrote:
> On Friday 24 October 2008 05:10:29 Linus Torvalds wrote:
> > It's been two weeks, so it's time to close the merge window. A 2.6.28-rc1
> > is out there, and it's hopefully all good.
> 
> It seems if you have a broken asm/ symlink in include/ (which happened as a 
> result of the x86 header moves, for me) the kernel won't try to update it 
> appropriately, and this breaks "make prepare".
> 
> $ make    ARCH=x86_64 prepare                                                                                                   
>   CHK     include/linux/version.h                                                                                                                            
>   CHK     include/linux/utsrelease.h                                                                                                                         
>   GEN     include/asm/asm-offsets.h                                                                                                                          
> /bin/sh: include/asm/asm-offsets.h: No such file or directory                                                                                                
> make[1]: *** [include/asm/asm-offsets.h] Error 1                                                                                                             
> make: *** [prepare0] Error 2
> 
> rm -f include/asm fixes it
> 
> This was just from taking a 2.6.27 tree, git clean -d -f, git pull, make 
> oldconfig. Might be a nice thing to fix?

Hm, I didn't have any problems with compiling .28-rc1 on x86_64.

[Confused.]

Rafael
