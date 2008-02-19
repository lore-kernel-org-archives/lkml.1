Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbYBSTcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbYBSTcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761249AbYBSTbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:31:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59651 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761246AbYBSTbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:31:23 -0500
Date: Tue, 19 Feb 2008 14:31:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andre Tomt <andre@tomt.net>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: USB OOPS 2.6.25-rc2-git1
In-Reply-To: <47BAF36C.4000509@tomt.net>
Message-ID: <Pine.LNX.4.44L0.0802191429570.13562-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Andre Tomt wrote:

> Got this on a serial console today, using 2.6.25-rc2-git1. Machine was 
> not doing anything interesting at the time, but has its / and kernel on 
> a usb-storage device (usb pen drive).
> 
> Intel ICH8R chipset (and USB controller), running x86_64 kernel. I'll 
> post .config and some additional info when I get home later if it isn't 
> obvious what broke.
> 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> > IP: [<ffffffff88063d11>] :ehci_hcd:end_unlink_async+0x17/0xfa

Can you provide some sort of disassembly listing of end_unlink_async, 
to determine which C statement contained the NULL pointer dereference?

Alan Stern

