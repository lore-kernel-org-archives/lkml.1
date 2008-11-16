Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYKPQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYKPQDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 11:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKPQDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 11:03:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:37449 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYKPQDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 11:03:02 -0500
Date: Sun, 16 Nov 2008 08:03:42 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bernhard Walle <bwalle@suse.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116080342.3d6c6976@infradead.org>
In-Reply-To: <20081116154541.1f196f1e@lxorguk.ukuu.org.uk>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<20081116150756.3cece2de@lxorguk.ukuu.org.uk>
	<20081116162003.04267538@kopernikus.site>
	<20081116154541.1f196f1e@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 15:45:41 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
ules that circumvent that
> > protection.
> 
> With your patch I get crap in the kernel I don't need. In every kernel
> including those on memory tight devices like wireless routers that
> don't need it.
> 
> You are turd polishing, and what is needed is a shovel.
> 
> Even if you want to turd polish there are cleaner solutions. A process
> with CAP_SYS_RAWIO can cheerfully bypass any restriction you try and
> place

because it can load kernel modules?
or because it can bypass the iommu?

the point of the /dev/mem restrictions is to not allow things you know
you don't need, while still allowing X to function where it can access
the crap it does. Now in Bernhard's case he DOES need them, so he
shouldn't use the restrictions.

> There are proper ways to deal with X, modern video cards and modern
> security models. They involve using framebuffer mappings off the PCI
> device node itself and DRI.
> 
when X has this for all hw that matters /dev/mem could go away for the
people who then no longer have any need for it.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
