Return-Path: <linux-kernel-owner+w=401wt.eu-S965248AbYCTAmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbYCTAmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967551AbYCTAec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:34:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932299AbYCTAe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:34:27 -0400
From: akepner@sgi.com
Date: Wed, 19 Mar 2008 17:32:58 -0700
To: Michael Ellerman <michael@ellerman.id.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Mark Nelson <mdnelson@au1.ibm.com>
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080320003258.GM1843@sgi.com>
References: <20080228032448.GS11012@sgi.com> <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com> <20080229182504.GA18102@colo.lackof.org> <1204310276.4003.48.camel@localhost.localdomain> <20080305181307.GR17802@sgi.com> <1204783306.14874.37.camel@concordia.ozlabs.ibm.com> <20080312011954.GN12370@sgi.com> <1205469029.7414.18.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205469029.7414.18.camel@concordia.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 03:30:29PM +1100, Michael Ellerman wrote:
> 
> I like this better, sorry to keep nitpicking, but just a few comments
> below ..

Comments are appreciated.

> ...
> You say a "DMA to a memory region with the DMA_ATTR_BARRIER attribute
> forces all pending DMA writes to complete". Does it force _all_ DMA
> writes to complete, or just writes to the region, or just writes coming
> from devices? What if something is writing to a device?
>

Yes, forces all writes to complete (as others have already said).

 
> Does DMA_ATTR_BARRIER have any effect on reads?
> 

No, changed the name to DMA_ATTR_WRITE_BARRIER to emphasize this.

-- 
Arthur

