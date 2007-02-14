Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbXBNJLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbXBNJLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXBNJLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:11:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53821 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbXBNJLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:11:39 -0500
Date: Wed, 14 Feb 2007 10:11:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, olecom@flower.upol.cz,
       zippel@linux-m68k.org
Subject: Re: kbuild feature/question: default ARCH
Message-ID: <20070214091144.GA25846@uranus.ravnborg.org>
References: <20070213220619.ce964f58.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213220619.ce964f58.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 10:06:19PM -0800, Randy Dunlap wrote:
> Hi,
> 
> I'd like for kbuild to default ARCH to the already-symlinked
> arch in include/asm-$(ARCH) if ARCH is not specified on the
> command line or in the environment.
Another approach I have been toying with previously was to
include ARCH in .config. But I somehow failed
to get it working and it went on my TODO list.

If kconfig get extended to so it can include Kconfig
files for all archs then it could be a Kconfig
option like anything else to select architecture
and this would also solve your issue.

As for the "export ARCH=i386" proposal this is of no
use for people crosscompiling a lot.
Think of the 'Al Viro' setup with crosscompile for 5+
different architectures.

But as I have no patches this is just cheap talk for now.

	Sam
