Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbXI1AV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbXI1AV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 20:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759216AbXI1AVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 20:21:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49785 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756896AbXI1AVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 20:21:21 -0400
From: akepner@sgi.com
Date: Thu, 27 Sep 2007 17:20:19 -0700
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, jejb <james.bottomley@steeleye.com>
Subject: Re: [PATCH 1/4] dma: add dma_flags_set_dmaflush() to dma interface
Message-ID: <20070928002019.GK30013@sgi.com>
References: <20070926000057.GL30013@sgi.com> <20070925221333.bb722dc4.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925221333.bb722dc4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 10:13:33PM -0700, Randy Dunlap wrote:
> On Tue, 25 Sep 2007 17:00:57 -0700 akepner@sgi.com wrote:
> ......
> 1.  Function signature should be on one line if possible (and it is).
> Aw crud, I looked at dma-mapping.h and it uses this format sometimes.
> Well, it's undesirable, so please don't propagate it.
> 
> 2.  No parens on return: it's not a function.
> 
> static inline int dma_flags_set_dmaflush(int dir)
> {
> 	return dir;
> }
> 
> 
> Similar comments for patch 2/4: sn-ia64.
> 

Both fixed in next version. Thanks, Randy.

-- 
Arthur

