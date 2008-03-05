Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbYCESOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbYCESOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYCESOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:14:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60124 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751351AbYCESOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:14:35 -0500
From: akepner@sgi.com
Date: Wed, 5 Mar 2008 10:13:07 -0800
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080305181307.GR17802@sgi.com>
References: <20080228032448.GS11012@sgi.com> <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com> <20080229182504.GA18102@colo.lackof.org> <1204310276.4003.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204310276.4003.48.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 12:37:56PM -0600, James Bottomley wrote:
> ....
> To be honest, I still don't like the name.  SYNC_ON_WRITE is the SN2
> implementation.  What it's actually doing is implementing strict
> ordering semantics.  I think it should really be
> DMA_ATTR_STRICT_ORDERING (with a corresponding
> DMA_ATTR_RELAXED_ORDERING)....

I've been thinking about a new name, but don't like 
DMA_ATTR_STRICT_ORDERING. 

What I'm trying to do is to establish order (across 
a NUMA fabric) of DMA to different memory regions, i.e., 
DMA to memory region A forces all outstanding DMA (to 
memory regions B, C,....) to complete first.

DMA_ATTR_STRICT_ORDERING sounds like a PCI thing to me, 
and this is a NUMA interconnect thing.

-- 
Arthur

