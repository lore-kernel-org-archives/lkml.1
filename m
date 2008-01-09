Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbYAIBE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbYAIBE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbYAIA53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:57:29 -0500
Received: from relay1.sgi.com ([192.48.171.29]:43133 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757519AbYAIA52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:57:28 -0500
From: akepner@sgi.com
Date: Tue, 8 Jan 2008 16:55:59 -0800
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <rdreier@cisco.com>, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
Message-ID: <20080109005559.GH23661@sgi.com>
References: <20080108023222.GP23661@sgi.com> <1199809628.3534.34.camel@localhost.localdomain> <ada63y4kycs.fsf@cisco.com> <1199814853.3534.39.camel@localhost.localdomain> <adawsqkjipz.fsf@cisco.com> <1199816504.3534.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199816504.3534.59.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 12:21:44PM -0600, James Bottomley wrote:
> ...
> But the point is that the Altix does something non-standard but which
> was later standardised (in a different way) largely so others could also
> benefit from the relaxed ordering speedup.
>

When you say that Altix does "something ... which was later 
standardized", what is "something"? 

The thing that I'm trying to address here is the reordering 
that may occur within the NUMA fabric. As far as I'm aware 
there's no standard for that.

-- 
Arthur

