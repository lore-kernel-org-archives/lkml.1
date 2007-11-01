Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXKARMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXKARMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXKARMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:12:02 -0400
Received: from xenotime.net ([66.160.160.81]:51651 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753581AbXKARMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:12:00 -0400
Date: Thu, 1 Nov 2007 10:11:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: kbuild problem
Message-Id: <20071101101157.90e194d3.rdunlap@xenotime.net>
In-Reply-To: <20071101052145.GA31445@uranus.ravnborg.org>
References: <20071031183900.46a0b529.rdunlap@xenotime.net>
	<20071101052145.GA31445@uranus.ravnborg.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 06:21:45 +0100 Sam Ravnborg wrote:

> On Wed, Oct 31, 2007 at 06:39:00PM -0700, Randy Dunlap wrote:
> > Hi Sam,
> > 
> > I have daily/nightly builds + test runs that use something like:
> > (but more complicated than this)
> > 
> > cp saved.config.file arch/$ARCH/config.default
> > EXPORT KBUILD_DEFCONFIG=config.default
> > make defconfig
> 
> KBUILD_DEFCONFIG is supposed to point out a file located in
> arch/$(ARCH)/configs.
> I assume you copy the file to that directory.

Oops, yes, the command that I entered above was missing the
/configs/ part, but it is there.

> Browsing the changes to scripts/kconfig/Makefile
> nothing says 'this is the bug' but I suggest you to look there
> first of all. 
> I do not have -git2 and -git3 handy to do a diff between.

I think I found it -- in my scripts.  :)
They still think that $ARCH is i386 or x86_64, not "x86".
I'm testing a fix for that now.

Thanks,
---
~Randy
