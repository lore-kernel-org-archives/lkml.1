Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYLFRqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYLFRqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYLFRqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:46:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60265 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYLFRql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:46:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] PCI: Suspend and resume PCI Express ports with interrupts disabled
Date: Sat, 6 Dec 2008 18:46:11 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061825.59914.rjw@sisk.pl> <alpine.LFD.2.00.0812060933430.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812060933430.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061846.12167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > I think it should go through Jesse?
> 
> Probably correct. And we want it in -next, so that it can get some testing 
> even before I open the merge window. Because I hope everybody realizes 
> that there's no way we're doing this in 2.6.28, and we'll leave the broken 
> and unreliable suspend.
> 
> Because afaik this is not a new bug (I tried to push a patch to do 
> suspend_late/resume_early for the PCI code a _loong_ time ago, but it 
> never got merged), and the only reason it showed up as a regression was 
> almost certainly simply that we've always had this.
> 
> IOW, suspend/resume has always been dodgy wrt interrupts, and there's some 
> luck involved. And your machine just happened to get unlucky.
> 
> I'd love to fix this in 2.6.28, but it's just not reasonable - it needs 
> widespread testing with an early -rc merge. And if it turns out to fix a 
> lot of machines, and there are no regressions, we can always back-port it 
> later.

I agree.

Thanks,
Rafael
