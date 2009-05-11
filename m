Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZEKJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZEKJWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbZEKJWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:22:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbZEKJWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:22:06 -0400
Date: Mon, 11 May 2009 05:22:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com
Subject: Re: [kdb] [PATCH 0/13] RFC ONLY - kdb for kgdb
Message-ID: <20090511092204.GA19351@infradead.org>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 04:23:07PM -0500, Jason Wessel wrote:
> This patch series is a request for comments on several levels.
> 
> 1) Do people find kdb useful? (See * and **)

Yes.

> 2) Would kdb folks be willing to use it if it was a front end to kgdb?

Yes.

> 3) Does kdb have a future in the mainline kernel?

Well, if someone invest the effort to clean it up, cut it into small
mergeable pieces and gets it done.

> 4) Is this a reasonable approach to have some level of
>    unification to end up with a more robust kernel debugger?

Sounds fine to me.

> To get the most basic functionality, you only need the first 2 patches
> in the series.  The remainder of the patches go on to incrementally
> add back some of the functionality that was removed from kdb.  I made
> an attempt to try to make the first part just the generic set of
> changes required to get kdb working on 1 or more archs.

Patch 1 still containes a lot random junk.  E.g. all those meminfo and
whatever hooks aren't required for a very basic kernel debugger.

