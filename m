Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYJXUSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYJXUSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYJXURw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:17:52 -0400
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:57636 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYJXURv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:17:51 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 16:17:51 EDT
Message-ID: <1224879041.49022bc1562bb@imp.free.fr>
Date: Fri, 24 Oct 2008 22:10:41 +0200
From: mathieu.taillefumier@free.fr
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mathieu Taillefumier <mathieu.taillefumier@free.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug] pci allocation resources problems on x86_64
References: <49019FE4.50001@free.fr> <4901A4C2.5020805@free.fr> <200810241131.55129.jbarnes@virtuousgeek.org>
In-Reply-To: <200810241131.55129.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 84.48.202.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Ultimately we need to do better at grabbing space for PCI allocations on x86.
> I was hoping we'd have some patches in 2.6.28 that would help here, but they
> weren't ready in time.  Can you file a kernel.org bug for this problem with
> the files attached?  I'll try to find time to put together some
> improvements...

yes sure. I will do that this weekend. I already grab some more information
about this problem by reading docs. The problem seems related to iommu setup
since it is not activated when the mem < 3G but activated when the mem>3G. I do
not understand however how the kernel can report more that 4g of memory when
there are only 4g installed (So I think that the bios is buggy too). I also
remarked that the size of the /proc/mem file is not what it is intended to be.
Another supprizing thing is these lines of the dmesg-not-working file

pci 0000:0a:00.0: BAR 0: got res [0x140000000-0x1400007ff] bus [0x140000000-0x14
00007ff] flags 0x20200
pci 0000:0a:00.0: BAR 0: moved to bus [0x140000000-0x1400007ff] flags 0x20200

it seems that the drivers setup some resources that way behind the available
memory.

Regards

MAthieu
