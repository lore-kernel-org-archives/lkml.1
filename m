Return-Path: <linux-kernel-owner+w=401wt.eu-S1422812AbXCBFP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422812AbXCBFP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422811AbXCBFP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:15:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57141 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422812AbXCBFP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:15:28 -0500
Date: Fri, 2 Mar 2007 05:15:24 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, support@coraid.com,
       "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-ID: <20070302051524.GA26803@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, support@coraid.com,
	"Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
	Greg KH <greg@kroah.com>
References: <20070301231510.GC8524@coraid.com> <20070301174204.a550dd3a.akpm@linux-foundation.org> <20070302022919.GA26285@infradead.org> <20070301192245.bf034385.akpm@linux-foundation.org> <20070302043039.GA18651@infradead.org> <20070301204806.61225e2b.akpm@linux-foundation.org> <20070302044910.GA22209@infradead.org> <20070301210044.d95bcd70.akpm@linux-foundation.org> <20070302050351.GA24705@infradead.org> <20070301210942.ebf40993.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301210942.ebf40993.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 09:09:42PM -0800, Andrew Morton wrote:
> > or document that drivers need to handle it specially and give them a
> > way to find out about them. (Or do the horrible slab refcounting hack
> > I wrote up above)
> 
> OK.  So you're proposing that XFS and ext3 simply stop sing slab for this
> memory?

Yes.
