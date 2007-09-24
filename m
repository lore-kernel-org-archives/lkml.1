Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbXIXSUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbXIXSUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbXIXSTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:19:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54641 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761192AbXIXSTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:19:51 -0400
Date: Mon, 24 Sep 2007 19:19:47 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 4/7] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070924181947.GB3810@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20070924164950.006047409@polymtl.ca> <20070924165427.717587684@polymtl.ca> <20070924174817.GB1608@infradead.org> <Pine.LNX.4.64.0709241413450.22210@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709241413450.22210@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 02:15:12PM -0400, Robert P. J. Day wrote:
> On Mon, 24 Sep 2007, Christoph Hellwig wrote:
> 
> > static inline void __mark_check_format(const char *fmt, ...)
> > 		__attribute__ ((format (printf, 1, 2)))
> > {
> > }
> 
> the header file compiler-gcc.h defines the shorter macro "__printf".
> is it worth encouraging its use, or does it matter?

Yes, that's even better.
