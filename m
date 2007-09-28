Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXI1TuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXI1TuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbXI1TuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:50:11 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:29460 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXI1TuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:50:09 -0400
X-IronPort-AV: E=Sophos;i="4.21,210,1188802800"; 
   d="scan'208";a="20701901"
To: akepner@sgi.com
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [4/4] mthca: allow setting "dmabarrier" on user-allocated memory
X-Message-Flag: Warning: May contain useful information
References: <20070928011353.GQ30013@sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 28 Sep 2007 12:50:00 -0700
In-Reply-To: <20070928011353.GQ30013@sgi.com> (akepner@sgi.com's message of "Thu, 27 Sep 2007 18:13:53 -0700")
Message-ID: <ada3awyo9hz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Sep 2007 19:50:02.0109 (UTC) FILETIME=[C231B2D0:01C80208]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not mentioning this earlier, but this patch should really be
two (or more) patches: one to add dmabarrier support to the core user
memory stuff in drivers/infiniband, and a second one to add support to
mthca (and more patches to add support to mlx4, cxgb3, etc, etc).

 > + * @dmabarrier: set "dmabarrier" attribute on this memory, if necessary 

Nit: just delete the "if necessary" since I don't think it makes
things clearer (and actually doesn't make much sense in this context)

Other than that this look fine to me, and I'm ready to merge it once
the necessary core DMA stuff is settled.

 - R.
