Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXDJId4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXDJId4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXDJId4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:33:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44923 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXDJIdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:33:55 -0400
Date: Tue, 10 Apr 2007 09:33:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ashok Raj <ashok.raj@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [patch 5/8] [Intel IOMMU] Graphics driver workarounds to provide unity map
Message-ID: <20070410083351.GA19691@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
	akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
	asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
	anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
	shaohua.li@intel.com
References: <20070409215552.221374000@intel.com> <20070409215723.969189000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409215723.969189000@intel.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 02:55:57PM -0700, Ashok Raj wrote:
> Most GFX drivers don't call standard PCI DMA APIs to allocate DMA buffer,
> Such drivers will be broken with IOMMU enabled. To workaround this issue, 
> we added two options.

All drm drivers do it.  If the usual out of tree crap vendors are too
stupid for their own sake it's their fault.

So NACK to this patch.

