Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbXHCRt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbXHCRt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXHCRtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:49:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43735 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763407AbXHCRtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:49:20 -0400
Date: Fri, 3 Aug 2007 13:49:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>,
       <linux-usb-devel@lists.sourceforge.net>, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default
 on certain device classes
In-Reply-To: <200708031808.11903.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0708031347270.3758-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Oliver Neukum wrote:

> Devices rarely simply crash.

It's rare, but it does happen.  I've seen a device get so messed up by 
suspend that it needed a reset; it wouldn't be surprising to find other 
devices requiring a power cycle.

Alan Stern

