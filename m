Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbXKFQPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbXKFQPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbXKFQO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:14:59 -0500
Received: from THUNK.ORG ([69.25.196.29]:53449 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbXKFQO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:14:59 -0500
Date: Tue, 6 Nov 2007 11:14:06 -0500
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
Message-ID: <20071106161406.GD9086@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net
References: <20071105215601.GA4612@kroah.com> <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org> <alpine.LFD.0.999.0711051414120.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711051414120.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 02:16:05PM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 5 Nov 2007, Linus Torvalds wrote:
> > 
> > This one is bogus:
> 
> Side note: I pulled and pushed out, since I assume the *code* is correct, 
> but please double-check the commit messages for things like this.
> 
> gitk makes it really easy, since it will highlight valid commit ID's. It 
> looks lik eyou may have re-ordered the commits or something?

hmm, I wonder if it would be a good idea to put together a git hook
script that looks for things that look like git commit ID's, and if
they aren't valid commit ID's that appear in the repository, the
maintainer gets a warning when they do a "git am" or otherwise suck in
a patch that was sent via e-mail...

  	     				- Ted
