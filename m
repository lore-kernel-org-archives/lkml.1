Return-Path: <linux-kernel-owner+w=401wt.eu-S1762523AbXKMVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762523AbXKMVwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbXKMVwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:52:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbXKMVwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:52:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <liml@rtr.ca>
Subject: Re: [BUG] New Kernel Bugs
Date: Tue, 13 Nov 2007 23:09:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, netdev@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-ide@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
References: <20071113.033946.114918709.davem@davemloft.net> <20071113184902.GG17785@parisc-linux.org> <4739F2DD.5050802@rtr.ca>
In-Reply-To: <4739F2DD.5050802@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132309.11874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 13 of November 2007, Mark Lord wrote:
> Matthew Wilcox wrote:
> > On Tue, Nov 13, 2007 at 01:43:53PM -0500, Mark Lord wrote:
> >
> >> mkdir t
> >> cd t
> >> git clone 
> >> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> >> (wait half an hour)
> >> /usr/bin/du -s linux-2.6
> >> 522732  linux-2.6
> > 
> > You're assuming that everything in linux-2.6 was downloaded; that's
> > not true.  Everything in linux-2.6/.git was downloaded; but then you do a
> > checkout which happens to approximately double the size of the linux-2.6
> > directory. 
> ..
> 
> Ah, I wondered why it took only half an hour to download.
> 
> ..
> > When you compare it to the 60MB tarballs that are published, it's really
> > not that bad.
> ..
> 
> The tarballs I download are only 45MB.

You clone the git repo once.  Afterwards, you only update it and that usually
doesn't take that much time and a little effort.

Greetings,
Rafael
