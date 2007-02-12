Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXBLRMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXBLRMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964984AbXBLRMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:12:44 -0500
Received: from verein.lst.de ([213.95.11.210]:43088 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989AbXBLRMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:12:43 -0500
Date: Mon, 12 Feb 2007 18:12:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: Christoph Hellwig <hch@lst.de>, tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [IA64] swiotlb abstraction (e.g. for Xen)
Message-ID: <20070212171224.GA18430@lst.de>
References: <200702070759.l177xIti030295@hera.kernel.org> <20070207083254.GA24561@lst.de> <20070211072555.GA22831@lst.de> <45D025BF.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D025BF.76E4.0078.0@novell.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 07:30:55AM +0000, Jan Beulich wrote:
> 
> As the topic says - the goal is to support Xen. But yes, I was afraid someone would
> claim this make the code look ugly. And no, I currently don't have ideas to address
> any of your comments without breaking functionality on Xen...

We don't have Xen merged, and it doesn't look like we're going to get it
soon.  Also the code is only for dom0 which will take even longer.
At this point I'm pretty sure the code is cleaner, simpler and easier to
maintain if you just split out a xendom0swiotlb instead of messing up
the existing code.
