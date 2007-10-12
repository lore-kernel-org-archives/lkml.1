Return-Path: <linux-kernel-owner+w=401wt.eu-S1761224AbXJLRF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbXJLRF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbXJLRFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:05:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53073 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbXJLRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:05:04 -0400
Date: Fri, 12 Oct 2007 10:01:40 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.1
Message-ID: <20071012170140.GA18498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.1 kernel.
It fixes a serious data corruption bug in the sata_mv driver, so any
user of that is strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.23 and 2.6.23.1

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------


 Makefile              |    2 +-
 drivers/ata/sata_mv.c |   27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 10 deletions(-)


Summary of changes from v2.6.23 to v2.6.23.1
============================================

Greg Kroah-Hartman (1):
      Linux 2.6.23.1

Jeff Garzik (1):
      libata: sata_mv: more S/G fixes

