Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbYEGDkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbYEGDkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYEGDjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:39:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50407 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbYEGDji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:39:38 -0400
Date: Tue, 6 May 2008 20:38:38 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.24.7
Message-ID: <20080507033838.GA10592@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.24.7 kernel.

Yeah, I said that there was not going to be anymore unless a security
issue happened, well, that's what happened.

This release fixes a security issue and all users of the 2.6.24 series
are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.24.6 and 2.6.24.7

The updated 2.6.24.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary

thanks,

greg k-h

--------

 Makefile   |    2 +-
 fs/locks.c |   17 +++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)


Al Viro (1):
      fix SMP ordering hole in fcntl_setlk() (CVE-2008-1669)

Greg Kroah-Hartman (1):
      Linux 2.6.24.7

