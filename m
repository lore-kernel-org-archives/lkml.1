Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYLKUkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYLKUkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbYLKUj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:39:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58820 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbYLKUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:39:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 3/3] Sound (HDA Intel): Restore PCI configuration space with interrupts off
Date: Thu, 11 Dec 2008 21:38:56 +0100
User-Agent: KMail/1.9.9
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812112103.17018.rjw@sisk.pl> <s5h7i66v4nb.wl%tiwai@suse.de>
In-Reply-To: <s5h7i66v4nb.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812112138.57145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 11 of December 2008, Takashi Iwai wrote:
> At Thu, 11 Dec 2008 21:03:16 +0100,
> Rafael J. Wysocki wrote:
> > 
> > On Thursday, 11 of December 2008, Takashi Iwai wrote:
> > > At Sun, 07 Dec 2008 10:47:56 +0100,
> > > I wrote:
> > > > 
> > > > At Sat, 6 Dec 2008 20:45:35 -0800,
> > > > Jesse Barnes wrote:
> > > > > 
> > > > > On Saturday, December 6, 2008 6:09 am Rafael J. Wysocki wrote:
> > > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > Subject: Sound (HDA Intel): Restore PCI configuration space with interrupts
> > > > > > off
> > > > > >
> > > > > > Move the restoration of the standard PCI configuration registers
> > > > > > in the snd_hda_intel driver to a ->resume_early() callback executed
> > > > > > with interrupts disabled, since doing that with interrupts enabled
> > > > > > may lead to problems in some cases.
> > > > > >
> > > > > > This patch addresses the regression from 2.6.26 tracked as
> > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=12121 .
> > > > > 
> > > > > Since I only applied 1 and 2 you'll need to send this one through Takashi.
> > > > 
> > > > OK, I merged it to for-next branch now.
> > > > It should appear in the linux-next tree of tomorrow.
> > > 
> > > There is no build errors at least on linux-next, but I guess the
> > > testing about PM has been rarely done on linux-next kernel...
> > > 
> > > BTW, Rafael, is this particular patch (against hda_intel.c) works in
> > > general or dependent on other two patches?
> > 
> > It should be safe without the other patches too.
> 
> OK, but this alone doesn't make much sense without others, right?
> 
> I'm asking this because I'm not pretty sure how this should be handled.
> Certainly it must be in 2.6.29, but about for 2.6.28...

Well, I think 2.6.29 would be fine.

Thanks,
Rafael
