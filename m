Return-Path: <linux-kernel-owner+w=401wt.eu-S1763678AbYBTVGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763678AbYBTVGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYBTVGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:06:16 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36409 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752743AbYBTVGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:06:15 -0500
Date: Wed, 20 Feb 2008 16:06:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <20080220215127.58b8ec70@mjolnir.drzeus.cx>
Message-ID: <Pine.LNX.4.44L0.0802201604260.7212-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Pierre Ossman wrote:

> > And why not simply fail the suspend if the resume routine doesn't exist
> > and the suspend routine does?  Maybe with an error message in the
> > system log.
> 
> For the asymmetric case, I guess that would do. But I still want to remove devices when the bus handler has no suspend handling.

Then it appears the correct approach is to use the new 
device_pm_schedule_removal() routine.  It schedules the removal of a 
suspended device for a time when the system suspend is over.

Alan Stern

