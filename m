Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYANVKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYANVKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYANVKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:10:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYANVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:10:03 -0500
Date: Mon, 14 Jan 2008 13:08:42 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.16
Message-ID: <20080114210842.GA3051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.16
kernel.

It contains a single fix for a problem that could cause a local user to
cause file system corruption on some types of filesystems.

All users of the 2.6.22 series are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.15 and 2.6.22.16

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile   |    2 +-
 fs/namei.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Summary of changes from v2.6.22.15 to v2.6.22.16
================================================

Greg Kroah-Hartman (1):
      Linux 2.6.22.16

Linus Torvalds (1):
      Use access mode instead of open flags to determine needed permissions (CVE-2008-0001)

