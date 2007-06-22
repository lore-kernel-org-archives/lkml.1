Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbXFVN76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbXFVN76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbXFVN7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:59:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35107 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755801AbXFVN7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:59:50 -0400
Date: Fri, 22 Jun 2007 09:59:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mattia Dongili <malattia@linux.it>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re:
 2.6.22-rc4-mm2]
In-Reply-To: <20070622092518.GD25100@inferi.kami.home>
Message-ID: <Pine.LNX.4.44L0.0706220957560.3290-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Mattia Dongili wrote:

> > Yes, the problem is not present after reverting this patch.
> 
> Not for me, I had that patch already reverted. As I said there was a
> point when bisecting which the kernel came back to life instead of just
> hanging trying to suspend.
> I'll try to get a trace with that. May the usb_storage verbose debug
> help there?

I've lost track of the start of this thread, so it would help to see a
dmesg log with CONFIG_USB_DEBUG turned on.  CONFIG_USB_STORAGE_DEBUG
doesn't matter so much because the usb-storage suspend and resume
routines don't do a lot of work.

Alan Stern

