Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYGPCjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYGPCjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 22:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390AbYGPCjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 22:39:45 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33333 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752382AbYGPCjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 22:39:44 -0400
Date: Tue, 15 Jul 2008 22:39:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080716023903.GP8185@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
	Marcel Holtmann <marcel@holtmann.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-kernel@vger.kernel.org
References: <1216150616.27455.377.camel@shinybook.infradead.org> <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org> <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151426021.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151436400.2867@woody.linux-foundation.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <20080716005133.GK8185@mit.edu> <20080716013619.GD17417@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716013619.GD17417@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 09:36:19PM -0400, Dave Jones wrote:
> Whilst it would be great for unified development on the tools that
> create the early boot process, I think it's a non-starter due to the
> fact that you can't really do it without throwing out everything you
> already have today.  The same reason imo, that hpa's klibc work hasn't
> gained mass-appeal from vendors.

Yeah, it would have been much better if we had included a reference
mkinitrd from the beginning, instead of saying, "Kernel doesn't set
policy", and hoping the distro's would converge on something similar.
The reality though is to the extent that we want to make changes like
request_firmware() we are actually better off setting policy for stuff
which is this low-level.

> Even if we had a 'reference' mkinitrd in the kernel, it would be
> pretty much useless until it reached feature parity with every
> distros existing tools, and if everyone uses those instead of
> furthering the reference implementation, it fails on the starting
> blocks.

In order to work now it would need to have a relatively simple way for
distro's to hook in their own enhancements, and someone would have to
do most of the work of migrating at least the major distro's to use
the new reference "official" mkinitrd.  It's something we should have
done from the very beginning, and it's a lot harder to fix up that
mistake years later.

							- Ted
