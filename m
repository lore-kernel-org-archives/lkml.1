Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYBXVLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYBXVLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYBXVLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:11:06 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2854 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754455AbYBXVLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:11:05 -0500
Date: Sun, 24 Feb 2008 16:11:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <200802242156.55948.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802241605340.17767-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove the code that acquires all device semaphores from the suspend
> code path as it causes multiple problems to appear (most notably,
> http://bugzilla.kernel.org/show_bug.cgi?id=10030) and revert the
> change introduced by commit 4145ed6dc597a9bea5f6ae8c574653b2de10620f
> depending on the code being removed.
> 
> Remove pm_sleep_lock()/pm_sleep_unlock() from device_add() to avoid
> the issue reported at http://bugzilla.kernel.org/show_bug.cgi?id=9874.

This looks okay.

Are you going to submit it just for 2.6.25, leaving the existing code 
as-is for 2.6.26?

Alan Stern

