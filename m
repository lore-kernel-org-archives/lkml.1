Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbXIURaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbXIURaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbXIUR3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:29:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57431 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbXIUR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:29:54 -0400
Date: Fri, 21 Sep 2007 18:29:50 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] Text Edit Lock for 2.6.23-rc6-mm1
Message-ID: <20070921172950.GA22972@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	linux-kernel@vger.kernel.org
References: <20070918210601.028313546@polymtl.ca> <20070920161018.0b4e7ec3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920161018.0b4e7ec3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 04:10:18PM -0700, Andrew Morton wrote:
> On Tue, 18 Sep 2007 17:06:01 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Here are the text edit lock patches ported to 2.6.23-rc6-mm1.
> 
> I think I'll duck these one more time.  There was a bit of followup
> and for now I'd prefer to concentrate on obviously-safe stuff and
> stabilisation of the current 2.6.24 queue.

As much as I'd love to see markers as soon as possible I have to agree.

I really hate how the first post of a handfull easy patches touching
almost no core code has turned into this gigantic series.

Matthew, any chance you could resurrect a trivial, no-optimizations
marker variant that has so little impact it could go into 2.6.24?

I'd really love to have the infrastructure there so we can add optimizations
in parallel with actually adding the users to the tree.
