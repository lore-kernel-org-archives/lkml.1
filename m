Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbYCDVBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbYCDVBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYCDVAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:00:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49114 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753932AbYCDVAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:00:52 -0500
Date: Tue, 4 Mar 2008 16:00:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
In-Reply-To: <200803041230.42152.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0803041558070.15986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Brownell wrote:

> > What's wrong with a superfluous probe at resume time, besides the waste 
> > of a few milliseconds?
> 
> I'm more concerned with the undesirable removal of devices at suspend
> time ... ones with mounted filesystems etc.

On that we can agree.  The removal is done if the host doesn't define a 
resume method.  There doesn't seem to be any point to that, given that 
the probing during resume will determine whether a card has in fact 
been removed.

Alan Stern

