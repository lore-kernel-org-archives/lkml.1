Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYLGMsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYLGMsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 07:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYLGMsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 07:48:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33584 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbYLGMsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 07:48:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sun, 7 Dec 2008 13:47:18 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812060952100.3425@nehalem.linux-foundation.org> <20081207054149.GA20415@kroah.com>
In-Reply-To: <20081207054149.GA20415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071347.18608.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 of December 2008, Greg KH wrote:
> On Sat, Dec 06, 2008 at 10:00:35AM -0800, Linus Torvalds wrote:
> > 
> > 
> > On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > > 
> > > So, to fix the issue at hand, I'd like the $subject patch to go first.  Then,
> > > there is a major update of the new framework waiting for .29 in the Greg's
> > > tree (that's the main reason why nobody uses it so far, BTW) and I'd really
> > > prefer it to go next.  After it's been merged, I'm going to add the mandatory
> > > suspend-resume things (save state and go to a low power state on suspend,
> > > restore state on resume) to the new framework in a separete patch.
> > > 
> > > Is this plan acceptable?
> > 
> > Sounds good to me. And assuming Jesse/Greg are all aboard, I'll just wait 
> > for the pull requests from Jesse and Greg.
> 
> No objection from me, I'll wait for Jesse to "go first" in the .29 merge
> window.

Unfortunately, the merge of the $subject patch with the one in your tree
results in code that doesn't compile.  Namely, some lines of code that the
$subject patch relies on are removed by the patch in your tree.

If there is no objection from Jesse and if you don't mind, I'll prepare a
version of the $subject patch on top of the patch in your tree and send it to
you.

Thanks,
Rafael
