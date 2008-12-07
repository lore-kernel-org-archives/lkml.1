Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYLGRcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYLGRcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYLGRcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:32:16 -0500
Received: from kroah.org ([198.145.64.141]:44640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbYLGRcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:32:15 -0500
Date: Sun, 7 Dec 2008 09:26:42 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Message-ID: <20081207172642.GC23744@kroah.com>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812060952100.3425@nehalem.linux-foundation.org> <20081207054149.GA20415@kroah.com> <200812071347.18608.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812071347.18608.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 01:47:18PM +0100, Rafael J. Wysocki wrote:
> On Sunday, 7 of December 2008, Greg KH wrote:
> > On Sat, Dec 06, 2008 at 10:00:35AM -0800, Linus Torvalds wrote:
> > > 
> > > 
> > > On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > > > 
> > > > So, to fix the issue at hand, I'd like the $subject patch to go first.  Then,
> > > > there is a major update of the new framework waiting for .29 in the Greg's
> > > > tree (that's the main reason why nobody uses it so far, BTW) and I'd really
> > > > prefer it to go next.  After it's been merged, I'm going to add the mandatory
> > > > suspend-resume things (save state and go to a low power state on suspend,
> > > > restore state on resume) to the new framework in a separete patch.
> > > > 
> > > > Is this plan acceptable?
> > > 
> > > Sounds good to me. And assuming Jesse/Greg are all aboard, I'll just wait 
> > > for the pull requests from Jesse and Greg.
> > 
> > No objection from me, I'll wait for Jesse to "go first" in the .29 merge
> > window.
> 
> Unfortunately, the merge of the $subject patch with the one in your tree
> results in code that doesn't compile.  Namely, some lines of code that the
> $subject patch relies on are removed by the patch in your tree.
> 
> If there is no objection from Jesse and if you don't mind, I'll prepare a
> version of the $subject patch on top of the patch in your tree and send it to
> you.

I sure don't mind.

thanks,

greg k-h
