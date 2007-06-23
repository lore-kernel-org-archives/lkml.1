Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbXFWMac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbXFWMac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXFWMaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:30:23 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:48472 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXFWMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:30:22 -0400
Date: Sat, 23 Jun 2007 14:30:18 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] fbdev: uvesafb
Message-ID: <20070623123018.GA1792@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070623104920.GA12623@spock.one.pl> <200706231404.09344.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706231404.09344.arnd@arndb.de>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 02:04:09PM +0200, Arnd Bergmann wrote:
> On Saturday 23 June 2007, Michal Januszewski wrote:
> >  The current implementation of v86d can use either LRMI or
> > x86emu to run the BIOS code and supports both x86 and x86_64.
> 
> Is there a fundamental reason why you can't also run it on
> non-x86 machines, or has this simply not been tested so far?

AFAIK it should be possible to get it to work on non-x86.  One would
have to implement the IO functions for x86emu and mmap the Video BIOS,
both of which should be relatively easy tasks.  I don't however have 
direct access to hardware other than x86(_64) and thus haven't had a
chance to write such code and test it.

Best regards,
Michal

