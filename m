Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbXJCRag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbXJCRag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbXJCRa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:30:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49888 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752411AbXJCRa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:30:28 -0400
From: akepner@sgi.com
Date: Wed, 3 Oct 2007 10:29:27 -0700
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mthca: allow setting "dmabarrier" on user-allocated memory
Message-ID: <20071003172927.GO26752@sgi.com>
References: <20071003025007.GJ26752@sgi.com> <20071003025645.GM3400@zakalwe.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003025645.GM3400@zakalwe.fi>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 05:56:45AM +0300, Heikki Orsila wrote:
> On Tue, Oct 02, 2007 at 07:50:07PM -0700, akepner@sgi.com wrote:
> > +struct mthca_reg_mr {
> > +	__u32 mr_attrs;
> > +#define MTHCA_MR_DMAFLUSH 0x1	/* flush in-flight DMA on a write to 
> > +				 * memory region */
> > +	__u32 reserved;
> > +};
> 
> Seems like a very odd place to #define something new..
> 

Lots of drivers do that - #define flags or whatever near the 
variable to which they apply. Didn't see any examples in the 
mthca driver though, so maybe it's setting a precedent there. 
If the maintainer objects, I'll move it.

--  
Arthur

