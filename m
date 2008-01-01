Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYAAAtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYAAAtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 19:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYAAAth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 19:49:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39262 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYAAAtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 19:49:36 -0500
Date: Tue, 1 Jan 2008 01:49:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Recursive variable `KBUILD_CFLAGS' references itself (eventually).
Message-ID: <20080101004937.GD22317@uranus.ravnborg.org>
References: <20071120001445.GA9243@redhat.com> <20071231131619.GE21871@uranus.ravnborg.org> <20071231161021.GC27655@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231161021.GC27655@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 11:10:21AM -0500, Dave Jones wrote:
> On Mon, Dec 31, 2007 at 02:16:19PM +0100, Sam Ravnborg wrote:
> 
>  > > Trying to do a 32bit build on a 64bit machine.
>  > > I did..
>  > >   make ARCH=i386 oldconfig
>  > >   make ARCH=i386 arch/x86/
>  > 
>  > Walking through my mailbox I found this one.
>  > I did not get similar reports and I cannot reproduce it.
>  > Do you continue to see this or had it been fixed somehow?
> 
> Still happens for me with the latest tree from git.
> 
> $ make ARCH=i386 arch/x86/
>   HOSTCC  scripts/kconfig/conf.o
>   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf -s arch/x86/Kconfig
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
> /mnt/raid0/src/linux-2.6/arch/x86/Makefile_32:43: *** Recursive variable `KBUILD_CFLAGS' references itself (eventually).  Stop.
> make: *** [arch/x86/] Error 2

Can reproduce it now. Will take a look tomorrow.

	Sam
