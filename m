Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXCVLlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXCVLlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 07:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030580AbXCVLlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 07:41:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60027 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030522AbXCVLlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 07:41:24 -0400
Date: Thu, 22 Mar 2007 12:41:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@outflux.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070322114144.GA29453@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com> <20070320192016.GC22797@outflux.net> <20070320214714.0e584cd4.akpm@linux-foundation.org> <20070321115955.GA18195@uranus.ravnborg.org> <1174555020.20505.89.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174555020.20505.89.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 09:17:00AM +0000, David Woodhouse wrote:
> On Wed, 2007-03-21 at 12:59 +0100, Sam Ravnborg wrote:
> > I will give it a shot tonight.
> 
> Thanks. I'll delete the syscalls-2.6.git tree now that you have it.
> 
> > One issue I have with current approach is that the ARCH specific
> > things are in a single .h file. 
> 
> Que? There aren't really any arch-specific things, except for a list of
> syscalls to be ignored which are i386-specific. That's because we're
> pulling in the 'master' system call list from asm-i386/unistd.h, and we
> need to exclude some of those which we don't really need on other
> architectures.
Yep - realized this when I took a closer look.
One thing striked my mind. It is correct that new things gets added
to i386 first these days?
To me it looks like x86_64 is growing larger than i386 among the
developers these days so using asm-x86_64/unistd.h could be a better choice?

	Sam
