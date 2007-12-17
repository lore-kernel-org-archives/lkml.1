Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbXLQS55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbXLQS55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbXLQS5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:57:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33774 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbXLQS5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:57:37 -0500
Date: Mon, 17 Dec 2007 10:56:49 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.24-rc5
Message-ID: <20071217185649.GB4330@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a single PCI fixes against your 2.6.24-rc5 git tree.

It reverts a previous patch that caused some problems with some
machine's expansion roms.  The proper fix for this will be in the next
release, so for now, let us restore the previous functionality so we do
not break any machines that were previous working just fine.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h

-------------

 drivers/pci/probe.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

---------------

Gary Hade (1):
      PCI: Restore PCI expansion ROM P2P prefetch window creation

