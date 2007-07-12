Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbXGLGiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbXGLGiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXGLGiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:38:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40922 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751722AbXGLGiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:38:08 -0400
Date: Thu, 12 Jul 2007 16:37:53 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070712063753.GV31489@sgi.com>
References: <200707111916.35036.jesper.juhl@gmail.com> <4695C564.5060500@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4695C564.5060500@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 11:08:36PM -0700, Jeremy Fitzhardinge wrote:
> Jesper Juhl wrote:
> >One of the big problem spots was XFS, but that got some stack usage 
> >fixes recently, and the 4K stack option has been around for quite a 
> >while now, so people really should have gotten around to fixing any 
> >code that can't handle it.   Are there still any big problem areas 
> >remaining?
> >  
> 
> I get frequent crashes when I use 4k stacks with XFS+lvm, using recent 
> kernels.  When did XFS stack use reductions go in?

February. They were fixes for gcc4.x stack usage regressions (i.e. a ~25%
increase) over gcc 3.3.5. They were not new stack reduction patches....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
