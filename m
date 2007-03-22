Return-Path: <linux-kernel-owner+w=401wt.eu-S934109AbXCVQ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109AbXCVQ2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934111AbXCVQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:28:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53341 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934109AbXCVQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:28:32 -0400
Date: Thu, 22 Mar 2007 17:28:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@outflux.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070322162827.GA31143@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com> <20070320192016.GC22797@outflux.net> <20070320214714.0e584cd4.akpm@linux-foundation.org> <20070321115955.GA18195@uranus.ravnborg.org> <1174555020.20505.89.camel@pmac.infradead.org> <20070322114144.GA29453@uranus.ravnborg.org> <1174580753.20505.120.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174580753.20505.120.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 04:25:53PM +0000, David Woodhouse wrote:
> On Thu, 2007-03-22 at 12:41 +0100, Sam Ravnborg wrote:
> > Yep - realized this when I took a closer look.
> > One thing striked my mind. It is correct that new things gets added
> > to i386 first these days?
> 
> Personally I tend to do PowerPC first, but most others seem to do i386,
> yes. There are still system calls being added to i386 and not x86_64...
> 
> init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
> init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented
> init/missing_syscalls.h:953:3: warning: #warning syscall lutimesat not implemented
> init/missing_syscalls.h:956:3: warning: #warning syscall revokeat not implemented
> init/missing_syscalls.h:959:3: warning: #warning syscall frevoke not implemented
> 
> > To me it looks like x86_64 is growing larger than i386 among the
> > developers these days so using asm-x86_64/unistd.h could be a better
> > choice?
> 
> Or perhaps the union of i386, x86_64 and powerpc. But I think i386 is
> good enough for now.
I kept i386 as default so all is good.

	Sam
