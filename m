Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZG0OmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZG0OmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZG0OmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:42:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41853 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751558AbZG0OmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:42:11 -0400
Date: Mon, 27 Jul 2009 10:42:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       <list@phuk.ath.cx>
Subject: Re: [Bug #13624] usb: wrong autosuspend initialization
In-Reply-To: <H5-1lZIIeYK.A.UqG.MXObKB@chimera>
Message-ID: <Pine.LNX.4.44L0.0907271041040.5614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13624
> Subject		: usb: wrong autosuspend initialization
> Submitter	:  <list@phuk.ath.cx>
> Date		: 2009-06-25 18:18 (32 days old)

There's some question as to whether this should be considered a kernel 
bug.  The kernel isn't doing anything wrong; the problem is that 
various userspace programs enable autosuspend for devices that can't 
support it properly.

Alan Stern

