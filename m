Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbXFZLOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbXFZLOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 07:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXFZLOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 07:14:25 -0400
Received: from the.earth.li ([193.201.200.66]:53544 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbXFZLOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 07:14:24 -0400
X-Greylist: delayed 1899 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 07:14:24 EDT
Date: Tue, 26 Jun 2007 11:42:41 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Michal Januszewski <spock@gentoo.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] fbdev: uvesafb
Message-ID: <20070626104241.GR8547@earth.li>
References: <20070623104920.GA12623@spock.one.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623104920.GA12623@spock.one.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 12:49:20PM +0200, Michal Januszewski wrote:
> uvesafb is a generic driver for VBE2+ compliant video cards; an enhanced
> version of vesafb and a direct successor of vesafb-tng [1].
> 
> uvesafb uses a userspace helper application (v86d, [2]) to run the x86
> Video BIOS code.  This makes it possible to include in uvesafb all the
> standard features (refresh rate control, video mode changes etc) that
> are missing from vesafb without resorting to ugly hacks such as the ones
> used in [1].  The current implementation of v86d can use either LRMI or
> x86emu to run the BIOS code and supports both x86 and x86_64.

Have you considered using libx86[1] in v86d? It looks very similar to
what you have at present and there are plans to extend it to non
x86(_64) archs.

J.

[1] http://www.codon.org.uk/~mjg59/libx86/

-- 
] http://www.earth.li/~noodles/ []         noodles is criminal         [
]  PGP/GPG Key @ the.earth.li   []                                     [
] via keyserver, web or email.  []                                     [
] RSA: 4DC4E7FD / DSA: 5B430367 []                                     [
