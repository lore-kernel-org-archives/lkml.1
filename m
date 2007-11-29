Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbXK2UNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbXK2UNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932663AbXK2UNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:13:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51989 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932648AbXK2UNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:13:40 -0500
Date: Thu, 29 Nov 2007 15:13:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
In-Reply-To: <474F1AAC.7040908@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0711291510200.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Mark Lord wrote:

> But the flogging continues multiple times per second
> until the system is shutdown, so it is "the next bug to fix".

That's not true.  The number of commands sent while probing a device is
predetermined and strictly limited.

In any case, what you're talking about is a SCSI issue -- not a USB 
issue.

Alan Stern

