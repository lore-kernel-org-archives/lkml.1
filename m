Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYKPQJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYKPQJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYKPQJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:09:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37093 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753286AbYKPQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:09:38 -0500
Date: Sun, 16 Nov 2008 16:09:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Bernhard Walle <bwalle@suse.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116160905.17e867da@lxorguk.ukuu.org.uk>
In-Reply-To: <20081116080342.3d6c6976@infradead.org>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<20081116150756.3cece2de@lxorguk.ukuu.org.uk>
	<20081116162003.04267538@kopernikus.site>
	<20081116154541.1f196f1e@lxorguk.ukuu.org.uk>
	<20081116080342.3d6c6976@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> because it can load kernel modules?
> or because it can bypass the iommu?

It has iopl, firmware loading, ioperm, raw disk I/O, mknod, module loading
etc etc.. 

> the point of the /dev/mem restrictions is to not allow things you know
> you don't need, while still allowing X to function where it can access
> the crap it does. Now in Bernhard's case he DOES need them, so he
> shouldn't use the restrictions.

I know what the point is, but it doesn't actually implement any
meaningful restriction to achieve that result, so it is worthless junk.

> > There are proper ways to deal with X, modern video cards and modern
> > security models. They involve using framebuffer mappings off the PCI
> > device node itself and DRI.
> > 
> when X has this for all hw that matters /dev/mem could go away for the
> people who then no longer have any need for it.

Why should it go away ? It's a matter of file permissions and security
rules as to who can access it. Trying to make it go away is just more
fake-security crap.

Alan
