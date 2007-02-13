Return-Path: <linux-kernel-owner+w=401wt.eu-S1750860AbXBMTwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860AbXBMTwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXBMTwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:52:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:41950 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXBMTwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:52:32 -0500
Date: Tue, 13 Feb 2007 11:51:16 -0800
From: Greg KH <greg@kroah.com>
To: torvalds@linux-foundation.org, agruen@suse.de, neilb@suse.de,
       viro@zeniv.linux.org.uk, hch@lst.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Bug in current -git tree causing dbus and gnome to chew up cpu time
Message-ID: <20070213195116.GA5181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've used 'git bisect' to track down a change in the latest git tree
that is causing dbus-daemon to sit and spin at the time GNOME launches,
preventing nautlius from ever running.

The bad commit is:
commit eb3dfb0cb1f4a44e2d0553f89514ce9f2a9fcaf1
Author: Andreas Gruenbacher <agruen@suse.de>
Date:   Mon Feb 12 00:51:47 2007 -0800

    [PATCH] Fix d_path for lazy unmounts

With that patch out, GNOME startup works just fine.  I have a strace of
the dbus process running showing the problem, if anyone thinks that will
help out any.

I'm running pretty new GNOME and dbus here:
	dbus 1.0.2
	gnome 2.16.2
	hal 0.5.7.1
	nautilus 2.16.3

Any ideas of things I can test?

thanks,

greg k-h
