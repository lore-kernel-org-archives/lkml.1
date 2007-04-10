Return-Path: <linux-kernel-owner+w=401wt.eu-S966135AbXDJJHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966135AbXDJJHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966137AbXDJJHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:07:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33349
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966135AbXDJJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:07:04 -0400
Date: Tue, 10 Apr 2007 02:07:02 -0700 (PDT)
Message-Id: <20070410.020702.88477115.davem@davemloft.net>
To: hch@infradead.org
Cc: ashok.raj@intel.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       ak@suse.de, gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, anil.s.keshavamurthy@intel.com,
       arjan@linux.intel.com, shaohua.li@intel.com
Subject: Re: [patch 5/8] [Intel IOMMU] Graphics driver workarounds to
 provide unity map
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070410083351.GA19691@infradead.org>
References: <20070409215552.221374000@intel.com>
	<20070409215723.969189000@intel.com>
	<20070410083351.GA19691@infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 10 Apr 2007 09:33:51 +0100

> On Mon, Apr 09, 2007 at 02:55:57PM -0700, Ashok Raj wrote:
> > Most GFX drivers don't call standard PCI DMA APIs to allocate DMA buffer,
> > Such drivers will be broken with IOMMU enabled. To workaround this issue, 
> > we added two options.
> 
> All drm drivers do it.  If the usual out of tree crap vendors are too
> stupid for their own sake it's their fault.
> 
> So NACK to this patch.

That's my feeling as well, everything we care about should be using
the proper APIs or else what is the point of them...
