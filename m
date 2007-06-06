Return-Path: <linux-kernel-owner+w=401wt.eu-S965872AbXFFXBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965872AbXFFXBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965630AbXFFXAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:00:50 -0400
Received: from waste.org ([66.93.16.53]:35959 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965646AbXFFXAt (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:00:49 -0400
Date: Wed, 6 Jun 2007 17:59:50 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070606225949.GV11166@waste.org>
References: <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org> <6934efce0706061140r4ed8436nf71d9b4aaf5c565e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0706061140r4ed8436nf71d9b4aaf5c565e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:40:58AM -0700, Jared Hulbert wrote:
> > The embedded people already use them
> >on flash which is a little dumb, but now we add even more cludge for
> >a non-block based access.
> 
> Please justify your assertion that using cramfs on flash is dumb.
> What would be not dumb?  In an embedded system with addressable Flash
> the linear addressing cramfs is simple and elegant solution.

Have to agree with Jared here, cramfs is a perfectly sensible thing to
use on many platforms. 

Adding the ability to make particular files XIP on those platforms is
also quite reasonable. 

The alternative would be to add a whole new filesystem to the kernel
(effectively obsoleting cramfs) just to add XIP support or to compile
in a second filesystem (ext2 w/XIP) just for a few files.

Keeping cramfs as a simple example filesystem is really not all that
worthwhile, given it's not much of an example.

-- 
Mathematics is the supreme nostalgia of our time.
