Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbYCETCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbYCETCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYCETCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:02:37 -0500
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:60595 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754184AbYCETCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:02:36 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: akepner@sgi.com
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs() interface
Date: Wed, 5 Mar 2008 11:02:02 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tony Luck <tony.luck@intel.com>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
References: <20080228032448.GS11012@sgi.com> <1204310276.4003.48.camel@localhost.localdomain> <20080305181307.GR17802@sgi.com>
In-Reply-To: <20080305181307.GR17802@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051102.03478.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2008 10:13 am akepner@sgi.com wrote:
> On Fri, Feb 29, 2008 at 12:37:56PM -0600, James Bottomley wrote:
> > ....
> > To be honest, I still don't like the name.  SYNC_ON_WRITE is the SN2
> > implementation.  What it's actually doing is implementing strict
> > ordering semantics.  I think it should really be
> > DMA_ATTR_STRICT_ORDERING (with a corresponding
> > DMA_ATTR_RELAXED_ORDERING)....
>
> I've been thinking about a new name, but don't like
> DMA_ATTR_STRICT_ORDERING.
>
> What I'm trying to do is to establish order (across
> a NUMA fabric) of DMA to different memory regions, i.e.,
> DMA to memory region A forces all outstanding DMA (to
> memory regions B, C,....) to complete first.
>
> DMA_ATTR_STRICT_ORDERING sounds like a PCI thing to me,
> and this is a NUMA interconnect thing.

Well, we used to call it a DMA barrier back in the old days, so 
DMA_ATTR_BARRIER might work (or DMA_ATTR_INTERCONNECT_BARRIER if you want to 
be extra clear about what it's doing).

Jesse
