Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbXJCBDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbXJCBDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXJCBD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:03:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44063 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753351AbXJCBD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:03:27 -0400
From: akepner@sgi.com
Date: Tue, 2 Oct 2007 18:02:25 -0700
To: Roland Dreier <rdreier@cisco.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [4/4] mthca: allow setting "dmabarrier" on user-allocated memory
Message-ID: <20071003010225.GC26752@sgi.com>
References: <20070928011353.GQ30013@sgi.com> <ada3awyo9hz.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada3awyo9hz.fsf@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 12:50:00PM -0700, Roland Dreier wrote:

> Sorry for not mentioning this earlier, but this patch should really be
> two (or more) patches: one to add dmabarrier support to the core user
> memory stuff in drivers/infiniband, and a second one to add support to
> mthca (and more patches to add support to mlx4, cxgb3, etc, etc).

Makes sense. 

> 
>  > + * @dmabarrier: set "dmabarrier" attribute on this memory, if necessary 
> 
> Nit: just delete the "if necessary" since I don't think it makes
> things clearer (and actually doesn't make much sense in this context)
>

OK.
 
> Other than that this look fine to me, and I'm ready to merge it once
> the necessary core DMA stuff is settled.
> 

Great. A new version of the patchset is on the way.

-- 
Arthur

