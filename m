Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZH3RRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZH3RRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 13:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZH3RRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 13:17:54 -0400
Received: from thunk.org ([69.25.196.29]:39296 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbZH3RRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 13:17:53 -0400
Date: Sun, 30 Aug 2009 13:17:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: memleaks, acpi + ext4 + tty
Message-ID: <20090830171749.GA8642@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com> <20090830163417.GA15183@skywalker.linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090830163417.GA15183@skywalker.linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 10:04:17PM +0530, Aneesh Kumar K.V wrote:
> > The ext4 reports are real leaks and patch was posted here -
> > http://lkml.org/lkml/2009/7/15/62. However, it hasn't been merged into
> > mainline yet (I cc'ed Aneesh).
> 
> The patch is part of ext4-patchqueue  http://repo.or.cz/w/ext4-patch-queue.git
> 
> Any plans to push the patches to linus tree soon ?

Yes, as soon as the next merge window opens.  The leak only shows up
when you mount and unmount a filesystem, which under normal
circumstances doesn't happen a huge number of times on most systems.
By the time it showed up it was late enough in the 2.6.31-rcX series
that I figured it was better to wait until the next merge window.  I
didn't consider it a high priority bug.

       	       	      	     	     	   - Ted
