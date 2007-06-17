Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbXFQFDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbXFQFDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 01:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXFQFDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 01:03:13 -0400
Received: from waste.org ([66.93.16.53]:41742 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXFQFDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 01:03:12 -0400
Date: Sun, 17 Jun 2007 00:02:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Message-ID: <20070617050255.GM11166@waste.org>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com> <20070614143248.736312f8.akpm@linux-foundation.org> <1182043500.2743.7.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182043500.2743.7.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 06:25:00PM -0700, Arjan van de Ven wrote:
> 
> > You: conceptully-new add-on which benefits 0.25% of the user base, provided
> > they select the right config options and filesystem.
> > 
> > Me: simpler enhancement which benefits 100% of the user base (ie: includes
> > 4k blocksize, 4k pagesize) and which also fixes your performance problem
> > with that HBA.
> 
> note that at least 2.6 is doing this "sort of", better than 2.4 at
> least. (30% hitrate or something like that).

Is it? Last I looked it had reverted to handing out reverse-contiguous
pages.

You can see this by running /proc/pid/pagemap through hexdump.

-- 
Mathematics is the supreme nostalgia of our time.
