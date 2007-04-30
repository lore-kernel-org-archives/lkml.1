Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXD3D6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXD3D6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 23:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXD3D6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 23:58:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51377 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965051AbXD3D6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 23:58:53 -0400
Date: Mon, 30 Apr 2007 13:58:38 +1000
From: David Chinner <dgc@sgi.com>
To: Zan Lynx <zlynx@acm.org>
Cc: Adrian Bunk <bunk@stusta.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
Message-ID: <20070430035838.GC77450368@melbourne.sgi.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177795118.7828.6.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 03:18:38PM -0600, Zan Lynx wrote:
> On Sat, 2007-04-28 at 21:19 +0200, Adrian Bunk wrote:
> > 4k stacks have become a well-tested feature used fore a long time in
> > Fedora and even in RHEL 4.
> 
> So has anyone fixed the bugs involving ext3 and LVM snapshots on top of
> DM mirror?

I doubt it.  Every time this comes up the problem of stacked I/O
configuration being able to reliably blow the 4k stack limit comes
up. Usually it's XFS that is blamed, but it seems ext3 and reiser
can both suffer from the same problem.  And now we can add things
like unionfs/ecryptfs into the stack as well....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
