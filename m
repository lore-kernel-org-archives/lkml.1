Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbXDKOws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbXDKOws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXDKOwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:52:47 -0400
Received: from waste.org ([66.93.16.53]:36030 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbXDKOwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:52:47 -0400
Date: Wed, 11 Apr 2007 09:40:09 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps#2: Move the page walker code to lib/
Message-ID: <20070411144009.GD11115@waste.org>
References: <7.469046093@selenic.com> <461C81C0.9040003@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461C81C0.9040003@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 04:35:44PM +1000, Nick Piggin wrote:
> Matt Mackall wrote:
> >Move the page walker code to lib/
> >
> >This lets it get shared outside of proc/ and linked in only when
> >needed.
> 
> Still should go into mm/
> 
> If it had, you might have also noticed your pagetable walking code
> is completely different from how everyone else does it, and fixed
> that too.

I actually did notice that, when I compared it to jsgf's page walking
code for Xen.
 
> BTW. Is it the case that unused and unexported symbols don't get
> pruned by the linker except inside lib/?

Yes, that's been my point all along. It also currently only happens at
the granularity of an object file, not a symbol, FYI.

-- 
Mathematics is the supreme nostalgia of our time.
