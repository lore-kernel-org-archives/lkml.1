Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbYBADJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbYBADJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 22:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYBADJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 22:09:18 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36094 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756113AbYBADJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 22:09:17 -0500
From: akepner@sgi.com
Date: Thu, 31 Jan 2008 19:07:51 -0800
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dma: document dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080201030751.GB28899@sgi.com>
References: <20080130055040.GS30022@sgi.com> <20080131223847.GA11872@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131223847.GA11872@colo.lackof.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 03:38:48PM -0700, Grant Grundler wrote:

Thanks for looking through this.

I'll send an updated patchset that addresses your comments 
as soon as I can - probably around Monday.

> ...
> > +struct dma_attrs encapsulates a set of "dma attributes". For the 
> > +definition of struct dma_attrs see linux/dma-attrs.h. 
> 
> Because all architectures will share the set of attrs definitions,
> would it be reasonable to document the intent of each attr?
> 
> Two reasons for doing this:
> 1) people reading the driver code should understand WHY the dma attr was added.
> 2) other arch maintainers need to know in order to implement the same attr
>    for their shiny new toys.
> 
> 
> > +The interpretation of dma attributes is architecture-specific. 
> 
> This statement is really important....but:
> Could we add a reference to arch documentation for each attr?
> 
> ie something public (doesn't have to be in linux source tree)
> which explains the subtlies of how that DMA attr actually works.
> 
> Having worked on HP chipsets for 10+ years, I know releasing
> original HW docs is often not possible. I'm not asking for the
> impossible. Please don't flame me for that. But if the company
> is willing to publish the existance of a feature, a paragraph or
> two would be good marketing too. Maybe just include comments in
> the arch/ code that implements the feature and reference those
> comments in DMA-API.txt.
> ....

OK, I can certainly add an explanation of the attribute that
I'm worried about. 

I think there's a reference to this behavior in our driver 
porting guide - I can add a pointer to that, too. 

This might also address your point above about documenting 
each attribute - let me know once the next patch is out.

-- 
Arthur

