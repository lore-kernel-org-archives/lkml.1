Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbXI1N3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbXI1N3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXI1N2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:28:53 -0400
Received: from vena.lwn.net ([206.168.112.25]:60374 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXI1N2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:28:52 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Chakri n" <chakriin5@gmail.com>
Subject: Re: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?) 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Thu, 27 Sep 2007 23:50:34 PDT."
             <20070927235034.ae7bd73d.akpm@linux-foundation.org> 
Date: Fri, 28 Sep 2007 07:28:52 -0600
Message-ID: <10659.1190986132@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> It's unrelated to the actual value of dirty_thresh: if the machine fills up
> with dirty (or unstable) NFS pages then eventually new writers will block
> until that condition clears.
> 
> 2.4 doesn't have this problem at low levels of dirty data because 2.4
> VFS/MM doesn't account for NFS pages at all.

Is it really NFS-related?  I was trying to back up my 2.6.23-rc8 system
to an external USB drive the other day when something flaked and the
drive fell off the bus.  That, too, was sufficient to wedge the entire
system, even though the only thing which needed the dead drive was one
rsync process.  It's kind of a bummer to have to hit the reset button
after the failure of (what should be) a non-critical piece of hardware.

Not that I have a fix to propose...:)

jon
