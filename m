Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbYDHVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbYDHVa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYDHVan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:30:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53697 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754108AbYDHVam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:30:42 -0400
From: akepner@sgi.com
Date: Tue, 8 Apr 2008 14:29:12 -0700
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v6] IB: expand ib_umem_get() prototype
Message-ID: <20080408212912.GI29410@sgi.com>
References: <20080401013744.GE29410@sgi.com> <adar6dgm8yi.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar6dgm8yi.fsf@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 12:40:21PM -0700, Roland Dreier wrote:
> All of this looks good to me, and I'm happy we are finally fixing this
> up.  However, now that it is finally ready to merge, I started thinking
> about the libmthca changes required to handle this, and I realized that
> we can actually avoid this:
> .....
> with my proposed change, the only difference is:
> 
>  new kernel, old userspace: current behavior (subtle failure on Altix),
>                             plus print a warning telling people to
>                             update userspace.
> ....
> 
> Andrew: if Arthur agrees with this, please roll the patch below into the
> current IB patch you have as part of the dma attrs series.

Sounds fine to me, Roland. 

Acked-by: Arthur Kepner <akepner@sgi.com>

-- 
Arthur

