Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbYBUXFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbYBUXFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYBUXFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:05:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35347 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752767AbYBUXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:05:08 -0500
Date: Thu, 21 Feb 2008 18:05:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802212347.25150.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802211803290.6236-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:

> BTW, below is a simplified version of the patch, without the mutex protecting
> suspending_task.  I'd like to push it upstream if it looks good.

It does look good.  Go ahead and push.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

> Please also have a look at http://bugzilla.kernel.org/show_bug.cgi?id=10030.
> There seems to be another issue related to us holding devices' semaphores.
> Namely, it looks like, when the user removes the card, a concurrent thread
> (from a workqueue) calls device_del() and blocks on the dev->sem held by
> us and then something else deadlocks with this thread.  I'll be looking into
> this tomorrow.

I've been too busy with other things to look at the activity on that 
bug report.  Tonight or tomorrow...

Alan Stern

