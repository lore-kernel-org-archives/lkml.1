Return-Path: <linux-kernel-owner+w=401wt.eu-S933923AbYB2VZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923AbYB2VZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760958AbYB2VZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:25:19 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40736 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756387AbYB2VZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:25:18 -0500
From: akepner@sgi.com
Date: Fri, 29 Feb 2008 13:23:50 -0800
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080229212350.GS11012@sgi.com>
References: <20080228032448.GS11012@sgi.com> <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 01:45:46PM +1100, Michael Ellerman wrote:
> ....
> I guess I think the attributes should either be truly arch-specific,
> ie. DMA_ATTR_IA64_SYNC_ON_WRITE. Or we need to come up with some well
> defined, and architecture neutral semantics for what the flags mean.
> 

I'd hoped to do just this - to define architecture neutral semantics 
for attributes. 

But I see your point - the documentation in DMA-attributes.txt isn't 
consistent with that plan. Let me see if I can address your concerns 
by changing the documentation. 

-- 
Arthur

