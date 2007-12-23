Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXLWM0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXLWM0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXLWM00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:26:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56330 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXLWM00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:26:26 -0500
Date: Sun, 23 Dec 2007 12:26:21 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, pagg@oss.sgi.com, erikj@sgi.com,
       matthltc@us.ibm.com, pj@sgi.com
Subject: Re: [PATCH 0/4] add task handling notifier
Message-ID: <20071223122621.GA19310@infradead.org>
References: <476A780C.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476A780C.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 01:11:24PM +0000, Jan Beulich wrote:
> With more and more sub-systems/sub-components leaving their footprint
> in task handling functions, it seems reasonable to add notifiers that
> these components can use instead of having them all patch themselves
> directly into core files.

I agree that we probably want something like this.  As do some others,
so we already had a few a few attempts at similar things.  The first one
is from SGI and called PAGG (http://oss.sgi.com/projects/pagg/) and also
includes allocating per-task data for it's users.  Then also from SGI
there has been a simplified version called pnotify that's also available
from the website above.

Later Matt Helsley had something called "Task Watchers" which lwn has
an article on: http://lwn.net/Articles/208117/.

For some reason neither ever made a lot of progess (performance
problems?).

As said by other we really should have a register/unregister API instead
of exposing the implementation.  Also please don't export anything until
we actuall grow modular users in the tree.

