Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbXIXCkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbXIXCkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 22:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXIXCkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 22:40:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:59635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbXIXCkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 22:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bkgef4O4uaOv3DFoZ1mi0gO0sMeH8IJ8D/ILPbJK4dW/gLQP7FFdDtQfwNxaKkb8Y2rEOjZREK3JXAzx64ApRTWkeDWZlx1JR1Sa1kA4YVHt/ByUc+MdBLiPuEN7KGyu7GQ4w4CG2GRfRZwWb7J1pvUioizEIuebx9UZOss0AYc=
Message-ID: <95455e980709231940m571c628cj887628aba4a21c4b@mail.gmail.com>
Date: Mon, 24 Sep 2007 12:40:07 +1000
From: hce <webmail.hce@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: Ethernet driver on 2.6.22
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070923183438.8807b5da.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <95455e980709231552l73bd8c78u46d3a45266749902@mail.gmail.com>
	 <20070923183438.8807b5da.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Randy.

On 9/24/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 24 Sep 2007 08:52:36 +1000 hce wrote:
>
> > Hi,
> >
> > I am upgrading from kernel 2.6.11 to 2.6.22 on ARM S3C2400A and found
> > a following issue on 2.6.22.
> >
> > On 2.6.11, I selected CONFIG_ISA,  CONFIG_NET_PCI and CONFIG_CS89X0 to
> > build  CS8900A Ethernet driver to kernel, it was running perfect.
> >
> > But on 2.6.22, I made the same configuration for CS8900A, the cs89x0.o
> > could not be compiled in to the kernel (or as a module when I tried to
> > CONFIG_CS89X0=m) unless I commented out depends statement in
> > drivers/net/Kconfig. I double checked all three are CONFIG_ISA=y,
> > CONFIG_NET_PCI=y and CONFIG_CS89X0=y. Any explanation please, was I
> > missing something here?
>
> I didn't look in 2.6.11 Kconfig files, but in 2.6.22, this driver is
> limited to 3 specific boards:
>
> config CS89x0
>         tristate "CS89x0 support"
>         depends on NET_PCI && (ISA || MACH_IXDP2351 || ARCH_IXDP2X01 || ARCH_PNX010X)

The Kconfig for CS89x0 in 2.6.11 is exactly the same as 2.6.22.

> Does ARM S3C2400A qualify as any of those?  (MACH_... or ARCH_...)

I can run CS89x0 for ARM S3C2400 in 2.6.11, at least I can say yes,
the ARM S3C2400A qualifies those in 2.6.11, I don't know the 2.6.22
and I hope someone knows 2.6.22 well can answer it.

> (latter: ARCH_PNX010X is not used anywhere else AFAICT)

Yes, but you only need to enable ISA and NET_PCI to use CS89x0.

> ---
> ~Randy
> Phaedrus says that Quality is about caring.
>

Thank you.

Kind regards,

Jim
