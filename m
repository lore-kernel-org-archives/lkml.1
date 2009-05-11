Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbZEKJXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbZEKJXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZEKJXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:23:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbZEKJXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:23:42 -0400
Date: Mon, 11 May 2009 05:23:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com
Subject: Re: [PATCH 0/13] RFC ONLY - kdb for kgdb
Message-ID: <20090511092342.GA23055@infradead.org>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com> <20090511091539.GM25550@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511091539.GM25550@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:15:39AM +0200, Louis Rilling wrote:
> Do you intend to support kdb modules? If yes, in which extent should they be
> adapted?

I think that would be a very low priority.  What would be useful is the
hack to load debuginfo into kdb so that it can pretty-print arbitrary
structures.  That alone would replace about 90% of the kdb modules I
think.

And yes, that code in current kdb is even more ugly than core kdb, so
it would need a major cleanup first.

