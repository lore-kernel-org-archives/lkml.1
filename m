Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZADWG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZADWG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbZADWGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:06:44 -0500
Received: from thunk.org ([69.25.196.29]:55493 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZADWGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:06:43 -0500
Date: Sun, 4 Jan 2009 17:06:34 -0500
From: Theodore Tso <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104220634.GD22958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rob Landley <rob@landley.net>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901041349.49906.rob@landley.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 01:49:49PM -0600, Rob Landley wrote:
> 
> Want to document the granularity issues with flash, while you're at it?
> 
> An inherent problem with using flash as a normal block device is that the 
> flash erase size is bigger than most filesystem sector sizes.  So when you 
> request a write, it may erase and rewrite the next 64k, 128k, or even a couple 
> megabytes on the really _big_ ones.
> 
> If you lose power in the middle of that, ext3 won't notice that data in the 
> "sectors" _after_ the one your were trying to write to got trashed.

True enough, although the newer SSD's will have this problem addressed
(although at least initially, they are **far** more costly than the
el-cheapo 32GB SD cards you can find at the checkout counter at Fry's
alongside battery-powered shavers and trashy ipod speakers).

I will stress again, that most of this doesn't belong in
Documentation/filesystems/ext3.txt, as most of this is *not*
ext3-specific.

						- Ted
