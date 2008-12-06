Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYLFVvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYLFVvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 16:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYLFVva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 16:51:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60674 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbYLFVva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 16:51:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sat, 6 Dec 2008 22:50:42 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061843.59495.rjw@sisk.pl> <20081206210927.445f0bc6@lxorguk.ukuu.org.uk>
In-Reply-To: <20081206210927.445f0bc6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812062250.43445.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Alan Cox wrote:
> > prefer it to go next.  After it's been merged, I'm going to add the mandatory
> > suspend-resume things (save state and go to a low power state on suspend,
> > restore state on resume) to the new framework in a separete patch.
> > 
> > Is this plan acceptable?
> 
> I have at least two drivers I look after where if you put the device into
> D3 you lost. We survive because on a successful suspend/resume sequence
> the BIOS puts it back coming out of suspend but that means we must not
> put those devices into D3 ourselves ever - including during a suspend
> before we are 100% comitted to the suspend completing or reboot.

We can mark them as devices not to put into D3.  There already is a
mechanism for that in place.

Thanks,
Rafael
