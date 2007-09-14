Return-Path: <linux-kernel-owner+w=401wt.eu-S932245AbXINOe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbXINOe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXINOem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:34:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57251 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932115AbXINOek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:34:40 -0400
Date: Fri, 14 Sep 2007 10:34:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Adrian Bunk <bunk@kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <20070914002416.GD14439@one-eyed-alien.net>
Message-ID: <Pine.LNX.4.44L0.0709141031450.3782-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Matthew Dharm wrote:

> > In fact, setting max_sectors down to 64 is probably overkill -- 120
> > ought to be enough.  But there may have been one or two oddball devices
> > that really did have a 32-KB limit, and better safe than sorry.  At one
> > point an engineer from Genesys said their devices did, although they do
> > seem to work perfectly well with 64-KB transfers (and that's what 
> > Windows gives them).
> 
> It's worth pointing out that performance drops like a stone as this number
> goes down.

Does anybody have good performance figures, using a high-quality
device?  This is the sort of thing where it helps to have some real
numbers.

Alan Stern

