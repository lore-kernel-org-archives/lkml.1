Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYCMRYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYCMRYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYCMRYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:24:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33709 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYCMRYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:24:19 -0400
Date: Thu, 13 Mar 2008 10:24:10 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [GIT PATCH] PCI fix for 2.6.25-rc5 git tree
Message-ID: <20080313172410.GA17045@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one PCI fix for your 2.6.25-rc5 git tree.

It fixes the duplicate sysfs entry problem as reported by Guennadi
Liakhovetski, now the machine can be properly shut down :)

The problem is also in 2.6.24 and earlier, but there we only get the
warning of a message saying that a link could not be created.  I'll send
a patch for -stable after this goes in as it will not directly apply
there.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

thanks,

greg k-h


-------------

 drivers/pci/bus.c   |    6 +++++-
 include/linux/pci.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

---------------

Greg Kroah-Hartman (1):
      PCI: fix issue with busses registering multiple times in sysfs

