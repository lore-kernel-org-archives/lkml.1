Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbXJYKUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbXJYKUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXJYKTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:19:54 -0400
Received: from verein.lst.de ([213.95.11.210]:57947 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXJYKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:19:54 -0400
Date: Thu, 25 Oct 2007 12:19:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwl3945: cleanup namespace
Message-ID: <20071025101948.GA21698@lst.de>
References: <20071012130500.GA22610@lst.de> <1193303997.3069.389.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193303997.3069.389.camel@debian.sh.intel.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 05:19:57PM +0800, Zhu Yi wrote:
> 
> On Fri, 2007-10-12 at 15:05 +0200, Christoph Hellwig wrote:
> > prefix all symbols with iwl3945_ and thus allow building the driver
> > into the kernel.  Also remove all the useless default statements in
> > Kconfig while we're at it.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Did you do this manually or with a script? If it is the latter, can you
> run it again against my latest updates for the driver (30 patches I just
> sent to linux-wireless) or share the script with me?

Basically just %s/iwl_/iwl<whatever>_/ in vi, with a tiny bit of
manual fixup. (one iwl_ function is actually coming from a still shared
beader and the BROADCAST_ADDR IIRC)
