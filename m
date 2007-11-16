Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXKPQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXKPQ5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXKPQ5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:57:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54504 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbXKPQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:57:11 -0500
Date: Fri, 16 Nov 2007 08:53:03 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Rob Landley <rob@landley.net>, WANG Cong <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken
	in 2.6.23.1)
Message-ID: <20071116165303.GA1002@kroah.com>
References: <200711032351.52977.rob@landley.net> <20071115210608.GA12213@kroah.com> <20071116030832.GB2563@hacking> <200711152301.44040.rob@landley.net> <20071116071527.GE31582@kroah.com> <20071116155108.GA5453@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116155108.GA5453@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 10:51:08AM -0500, Jeff Dike wrote:
> On Thu, Nov 15, 2007 at 11:15:27PM -0800, Greg KH wrote:
> > Rob, I'll queue this up for the next cycle, now that you've verified
> > that it was not fixed already, thanks for testing.
> 
> I wouldn't.
> 
> sparc includes swap.h in its pgtable.h.  Adding pagemap.h to swap.h
> completes an include loop on sparc which blows up its build.

Ok, nevermind, I'll drop it from my to-add queue :)

thanks for letting me know.

greg k-h
