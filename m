Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbXJXQNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbXJXQNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXJXQNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:13:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47781 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbXJXQNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:13:14 -0400
Date: Wed, 24 Oct 2007 18:14:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>, sparclinux@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071024161448.GA3166@uranus.ravnborg.org>
References: <200710111754.46854.rob@landley.net> <20071024152240.GA7733@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024152240.GA7733@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff.

On Wed, Oct 24, 2007 at 11:22:40AM -0400, Jeff Dike wrote:
> On Thu, Oct 11, 2007 at 05:54:46PM -0500, Rob Landley wrote:
> > Guess what?  I still need this patch to build the final 2.6.23, months later.
> > 
> > I know it may not be the right fix, but the build breaks for me without this 
> > patch. The .config that breaks is attached.  ARCH=um.
> 
> Can I get a Signed-off-by: on that?
> 
> It's not the right fix - the base of the problem is in swap.h, which
> has this comment: 
> 	/* only sparc can not include linux/pagemap.h in this file
> 	 * so leave page_cache_release and release_pages undeclared... */
> 
> I poked around a bit for a sparc cross-toolchain, didn't find one, so
> I couldn't see what exactly the problem was.
> 
> So, I'll take this fix.

Dan Kegel's crosstool builds sparc just fine.
And for sparc issues I recommend cc:ing the sparc ML.

[Original mail (with patch) is here: http://lkml.org/lkml/2007/10/11/288]

	Sam
