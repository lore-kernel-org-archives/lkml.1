Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbXCCFej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbXCCFej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 00:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXCCFei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 00:34:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733AbXCCFed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 00:34:33 -0500
Date: Fri, 2 Mar 2007 21:33:42 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.19.7
Message-ID: <20070303053342.GA28614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.19.7 kernel.
It turns out that I forgot some patches that had already been submitted
to me, hence the new release.

It contains some DVB bugfixes, so anyone who uses that subsystem is
recommended to upgrade, otherwise 2.6.19.6 is fine.

Barring anything major, there will not be any more 2.6.19 releases.  If
you disagree with this, please let the stable team know about the
patches that you feel must be in a new release.  We need to move on to
flushing out the very large backlog of 2.6.20-stable patches.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.19.6 and 2.6.19.7, as it is small enough to do so.

The updated 2.6.19.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.19.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h
--------

 Makefile                            |    2 +-
 drivers/media/dvb/dvb-core/dvbdev.c |   13 +++++++++++++
 drivers/media/dvb/dvb-usb/cxusb.c   |    4 ++--
 drivers/media/dvb/dvb-usb/digitv.c  |    2 ++
 4 files changed, 18 insertions(+), 3 deletions(-)

Summary of changes from v2.6.19.6 to v2.6.19.7
==============================================


Greg Kroah-Hartman (1):
      Linux 2.6.19.7

Jin-Bong lee (1):
      DVB: cxusb: fix firmware patch for big endian systems

Marcel Siegert (1):
      dvbdev: fix illegal re-usage of fileoperations struct

Michael Krufky (1):
      DVB: digitv: open nxt6000 i2c_gate for TDED4 tuner handling

