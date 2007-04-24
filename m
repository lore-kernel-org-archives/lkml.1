Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbXDXXTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbXDXXTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 19:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXDXXTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 19:19:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32864 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754546AbXDXXTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 19:19:17 -0400
Date: Wed, 25 Apr 2007 00:22:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: ashok.raj@intel.com, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when
 devices cannot address entire range.
Message-ID: <20070425002208.732d4bda@the-village.bc.nu>
In-Reply-To: <20070424.145026.128110905.davem@davemloft.net>
References: <200704242312.54738.ak@suse.de>
	<20070424.142351.62664098.davem@davemloft.net>
	<20070424213835.GB31920@linux-os.sc.intel.com>
	<20070424.145026.128110905.davem@davemloft.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 14:50:26 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Ashok Raj <ashok.raj@intel.com>
> Date: Tue, 24 Apr 2007 14:38:35 -0700
> 
> > Its not clear if we have a very generic device breakage.. most devices
> > on these platforms are going to be more recent, (except maybe some
> > legacy fd)... 
> 
> I'm not so sure, there are some "modern" sound cards that have
> a 31-bit DMA addressing limitation because they use the 31st
> bit as a status bit in their DMA descriptors :-)

The sound stuff is going away bit by bit thankfully, but the 30bit DMA
limit is present on some more demented wireless chips still.

Alan
