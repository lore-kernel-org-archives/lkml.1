Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbXDMJqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbXDMJqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXDMJqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:46:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37436 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbXDMJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:46:17 -0400
Date: Fri, 13 Apr 2007 10:46:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413094610.GA8875@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	William Lee Irwin III <wli@holomorphy.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com> <461F2BCB.2020200@yahoo.com.au> <20070413075142.GA23822@infradead.org> <461F3961.6030300@yahoo.com.au> <20070413081338.GA27675@infradead.org> <461F3E8A.9010902@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461F3E8A.9010902@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 06:25:46PM +1000, Nick Piggin wrote:
> But at least make it into its own module with a debugfs interface or
> something. I mean, exposing a PG_name-to-nr and page count pfn and flags
> as a supposedly formal proc interface doesn't sound nice to me. Page
> flags does not tell you what is going on in the VM, it gives you a tiny
> window into "something". Between reading a /proc/pid/ pfn and finding
> the pfn's page flags, it could be used for something completely different
> anyway.

I agree that exposing numerical values of page flags is not a very good
idea at all.  If we really want to expose this information it should
at least be in string form, although that is quite a bit of a maintaince
horror aswell.

