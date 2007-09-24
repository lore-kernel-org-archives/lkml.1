Return-Path: <linux-kernel-owner+w=401wt.eu-S1762351AbXIXSBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351AbXIXSBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbXIXSA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:00:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33654 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbXIXSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:00:57 -0400
Date: Mon, 24 Sep 2007 19:00:41 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-ID: <20070924180041.GB2435@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>
References: <20070924164950.006047409@polymtl.ca> <20070924165428.335030720@polymtl.ca> <20070924175044.GD1608@infradead.org> <20070924105632.009aba7f.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924105632.009aba7f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 10:56:32AM -0700, Randy Dunlap wrote:
> I don't have a problem with a samples/ directory except (as I have
> already pointed out) it means that people will end up having to look
> in 2 places for the information that they need, i.e., both in
> samples/ and in Documentation/.  So I really don't see a big need
> to split the samples and docs.
> 
> What's wrong with building sample code in the Documentation/ directory?

It's not really documentation, it's code :)  If you want to build
documentation from the samples use kerneldoc or similar to extrace the
comments.  Having Documentation/ purely for things not affecting the build
make things a whole lot clearer, but if you absolutely insist on it
we can put it under Documentation/ as long as it's fully integrated into
kbuild and will be built as part of allmodconfig, unlike the current
two patches showing code there.
