Return-Path: <linux-kernel-owner+w=401wt.eu-S1030940AbXDVPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030940AbXDVPOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030941AbXDVPOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 11:14:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60962 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030940AbXDVPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 11:14:19 -0400
Date: Sun, 22 Apr 2007 16:17:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kkeil@suse.de, i4ldeveloper@listserv.isdn4linux.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
Message-ID: <20070422161708.54253ab7@the-village.bc.nu>
In-Reply-To: <462B712D.7070504@imap.cc>
References: <20070115172912.GA3323@pingi.kke.suse.de>
	<462A0CA7.2090908@imap.cc>
	<20070421215844.542d3aab@the-village.bc.nu>
	<20070421.151052.78709111.davem@davemloft.net>
	<462B54A0.9000203@imap.cc>
	<20070422135835.037e323c@the-village.bc.nu>
	<462B712D.7070504@imap.cc>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> obsolete and correctly re-labelled as such. As for the && !HOTPLUG
> menace you keep touting, that might perhaps be applied to some of
> the individual hardware device drivers but certainly not to the

In my tree its just the drivers that still use pci_find_device.

> > Want to be on that. There is nobody maintaining it. That isn't a
> > sustainable situation so it will break.
> 
> Not sure I'm following you. There is an official maintainer, and
> although he's currently rather silent on this topic, there's no
> reason to believe he won't step up if there's actually some urgent
> maintaining to be done.

Well once it ends up && BROKEN perhaps patches will appear, or before
that. If not well the pain factor will resolve the problem.

> > No risk of deadlock. It'll progress to && BROKEN which will either cause
> > sufficient pain for someone to get off their arse and fix it, for enough
> > of a vendors users to get the vendor to do the work or for someone who
> > cares to pay a third party to do the work.
> 
> Do I sense some hidden agenda there?

No I'm speaking from experience - if a subsystem maintainer is too
busy/working on other projects and the subsystem stops working it
produces a rapid and sudden supply of new maintainers, unless nobody
cares in which case it can go in the bitbucket.

> The isdn4linux subsystem will not "progress" to BROKEN unless
> somebody pushes it there. 

It has drivers using functions that will soon be deleted. That isn't so
much as pushing more like getting fed up of pulling someone elses cart
along.

