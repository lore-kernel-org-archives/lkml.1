Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbXLRWr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbXLRWr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXLRWrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:47:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55072 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbXLRWrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:47:48 -0500
Date: Tue, 18 Dec 2007 14:45:59 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.12
Message-ID: <20071218224559.GA12696@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.12 kernel.
It just reverts one patch that has been causing some users some
problems.  For details about the problems, see:
	http://bugzilla.kernel.org/show_bug.cgi?id=9514
If you are not having any problems with the 2.6.23.11 kernel, then there
is no need to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.23.11 and 2.6.23.12

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                       |    2 +-
 drivers/pnp/pnpacpi/rsparser.c |   15 ++-------------
 include/linux/pnp.h            |    4 ++--
 3 files changed, 5 insertions(+), 16 deletions(-)


Summary of changes from v2.6.23.11 to v2.6.23.12
================================================

Greg Kroah-Hartman (2):
      Revert "PNP: increase the maximum number of resources"
      Linux 2.6.23.12

