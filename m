Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYAHRwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYAHRwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYAHRwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:52:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45621 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYAHRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:52:04 -0500
Date: Tue, 8 Jan 2008 17:50:54 +0000
From: Christoph Hellwig <hch@infradead.org>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_*
	routines
Message-ID: <20080108175054.GA25168@infradead.org>
References: <20080108023222.GP23661@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108023222.GP23661@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 06:32:22PM -0800, akepner@sgi.com wrote:
> 
> The following patchset allows additional "attributes" to be 
> passed to dma_map_*/dma_unmap_* implementations. (The reason 
> why this is useful/necessary has been mentioned several times, 
> most recently here:
> http://marc.info/?l=linux-kernel&m=119258541412724&w=2.)
> 
> This is incomplete in that only ia64 and x86_64 are supported - 
> the purpose is mainly to give us something specific to discuss. 
> 
> The approach here is to change the dma_map_* interface so 
> that the last argument is an u32 which encodes the direction 
> of the dma and, optionally, other attributes. Changing the 
> interface is a bit intrusive, but callers of dma_map_* don't 
> need to be modified.

Onething I've missed with these patches is drivers actually using
it.  What driver actually needs it and why don't you send patches
for them?
