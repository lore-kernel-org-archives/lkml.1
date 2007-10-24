Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXJXPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXJXPXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbXJXPXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:23:07 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:40564 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbXJXPXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:23:06 -0400
Date: Wed, 24 Oct 2007 11:22:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071024152240.GA7733@c2.user-mode-linux.org>
References: <200710111754.46854.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710111754.46854.rob@landley.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 05:54:46PM -0500, Rob Landley wrote:
> Guess what?  I still need this patch to build the final 2.6.23, months later.
> 
> I know it may not be the right fix, but the build breaks for me without this 
> patch. The .config that breaks is attached.  ARCH=um.

Can I get a Signed-off-by: on that?

It's not the right fix - the base of the problem is in swap.h, which
has this comment: 
	/* only sparc can not include linux/pagemap.h in this file
	 * so leave page_cache_release and release_pages undeclared... */

I poked around a bit for a sparc cross-toolchain, didn't find one, so
I couldn't see what exactly the problem was.

So, I'll take this fix.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
