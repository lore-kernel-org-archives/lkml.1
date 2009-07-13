Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbZGMEWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbZGMEWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 00:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZGMEV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 00:21:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:58428 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZGMEVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 00:21:55 -0400
Date: Mon, 13 Jul 2009 13:20:26 +0900
To: Ian.Campbell@citrix.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, jeremy@goop.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, benh@kernel.crashing.org, tony.luck@intel.com,
       x86@kernel.org, beckyb@kernel.crashing.org, joerg.roedel@amd.com
Subject: Re: [00/15] swiotlb cleanup
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1247234520.4002.418.camel@zakaz.uk.xensource.com>
References: <20090710051236.GA22218@elte.hu>
	<20090710143408A.fujita.tomonori@lab.ntt.co.jp>
	<1247234520.4002.418.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090713131859N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 13:20:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 15:02:00 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Fri, 2009-07-10 at 14:35 +0900, FUJITA Tomonori wrote:
> > I don't think that we need to take account of dom0 support; we don't
> > have a clear idea about an acceptable dom0 design (it needs to use
> > swiotlb code? I don't know yet), we don't even know we will have dom0
> > support in mainline. That's why I didn't CC this patchset to Xen
> > camp.
> 
> The core domain 0 patches which were the subject of the discussions a
> few week back are completely orthogonal to the swiotlb side of things

? If we don't merge dom0 patch, we don't need dom0 changes to
swiotlb. We don't know we would have dom0 support in mainline. Or I
overlooked something?


> and whatever form they eventually take I do not think it will have any
> impact on the shape of the solution which we arrive at for swiotlb. I
> don't think that assuming that domain 0 can never be done in a way which
> everyone finds acceptable and therefore discounting all consideration of
> it is a useful way to make progress with these issues.
> 
> The DMA use case is much more tightly tied to the paravirtualized MMU
> (which is already in the kernel for domU purposes) than it is to "the
> domain 0" patches anyway. Although domain 0 is probably the main use
> case, at least today, swiotlb support is also used in a Xen domU as part
> of the support for direct assignment of PCI devices to paravirtualised
> guests (pci passthrough).
> 
> The pci frontend driver depends on some bits of the domain 0 physical
> interrupt patches as well as swiotlb which is why I/we haven't tried to
> upstream that particular series yet.

As far as I know, you have not posted anything about changes to
swiotlb for domU. I can't discuss it. If you want, please send
patches.
