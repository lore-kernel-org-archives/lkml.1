Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbYLGF5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbYLGF5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 00:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYLGF5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 00:57:18 -0500
Received: from kroah.org ([198.145.64.141]:38438 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751262AbYLGF5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 00:57:17 -0500
Date: Sat, 6 Dec 2008 21:41:49 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Message-ID: <20081207054149.GA20415@kroah.com>
References: <200812020320.31876.rjw@sisk.pl> <200812061822.35763.rjw@sisk.pl> <alpine.LFD.2.00.0812060930490.3425@nehalem.linux-foundation.org> <200812061843.59495.rjw@sisk.pl> <alpine.LFD.2.00.0812060952100.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812060952100.3425@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 10:00:35AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > So, to fix the issue at hand, I'd like the $subject patch to go first.  Then,
> > there is a major update of the new framework waiting for .29 in the Greg's
> > tree (that's the main reason why nobody uses it so far, BTW) and I'd really
> > prefer it to go next.  After it's been merged, I'm going to add the mandatory
> > suspend-resume things (save state and go to a low power state on suspend,
> > restore state on resume) to the new framework in a separete patch.
> > 
> > Is this plan acceptable?
> 
> Sounds good to me. And assuming Jesse/Greg are all aboard, I'll just wait 
> for the pull requests from Jesse and Greg.

No objection from me, I'll wait for Jesse to "go first" in the .29 merge
window.

thanks,

greg k-h
