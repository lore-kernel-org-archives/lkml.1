Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbXCUQBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbXCUQBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXCUQBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:01:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37359 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXCUQBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:01:14 -0400
Date: Wed, 21 Mar 2007 16:00:51 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Adam Litke <agl@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated helper macros.
Message-ID: <20070321160051.GA5264@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Adam Litke <agl@us.ibm.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	William Lee Irwin III <wli@holomorphy.com>,
	Ken Chen <kenchen@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <20070319200513.17168.52238.stgit@localhost.localdomain> <4600B216.3010505@yahoo.com.au> <1174490261.21684.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174490261.21684.13.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 10:17:40AM -0500, Adam Litke wrote:
> > Also, it is going to be hugepage-only, isn't it? So should the naming be
> > changed to reflect that? And #ifdef it...
> 
> They are doing some interesting things on Cell that could take advantage
> of this.

That would be new to me.  What we need on Cell is fixing up the
get_unmapped_area mess which Ben is working on now.

And let me once again repeat that I don't like this at all.  I'll
rather have a few ugly ifdefs in strategic places than a big object
oriented mess like this with just a single user.

