Return-Path: <linux-kernel-owner+w=401wt.eu-S967623AbYCTAlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967623AbYCTAlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935465AbYCTAa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:30:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57227 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761217AbYCTAa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:30:56 -0400
From: akepner@sgi.com
Date: Wed, 19 Mar 2008 17:29:28 -0700
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 v4] dma: dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080320002928.GL1843@sgi.com>
References: <20080313040022.GJ12370@sgi.com> <20080313014106.782aa3c7.akpm@linux-foundation.org> <20080313082754.3da94420.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313082754.3da94420.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 08:27:54AM -0700, Randy Dunlap wrote:

Thanks for looking at this. A new patchset is on the way.

> On Thu, 13 Mar 2008 01:41:06 -0700 Andrew Morton wrote:
> 
> > > +#ifdef ARCH_USES_DMA_ATTRS
> > 
> > There is no precedent for ARCH_USES_*.
> > 
> > There is a little bit of precedent for ARCH_HAVE_*
> > 
> > There is lots of precendence for ARCH_HAS_*.
> > 
> > We don't like ARCH_HAS_* anyway ;) What can we do to get rid of this? 
> > Ideally, make it available on all architectures at zero cost to those which
> > don't need it.  If that is impractical (why?) then it is preferable to do
> > this in Kconfig.
> 
> Sam has been pushing HAVE_* and even added that to
> Documentation/kbuild/kconfig-language.txt.

OK, changed it to CONFIG_HAVE_DMA_ATTRS.

> 
> > > +/*
> > > + * dma_set_attr - set a specific attribute
> > > + * may be called with a null attrs
> > > + */
> 
> Use kernel-doc notation?

Done.

-- 
Arthur

(503) 234 4671
