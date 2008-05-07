Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbYEGDjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbYEGDjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbYEGDjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:39:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50393 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbYEGDja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:39:30 -0400
Date: Tue, 6 May 2008 20:36:07 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.2
Message-ID: <20080507033607.GA10503@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.2 kernel.

It fixes one pretty nasty security bug.  All users of the 2.6.25 series
are strongly encouraged to upgrade.

Many thanks to Al Viro for finding and fixing this problem.

I'll also be replying to this message with a copy of the patch between
2.6.25.1 and 2.6.25.2

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

--------

 Makefile   |    2 +-
 fs/locks.c |   17 +++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)


Al Viro (1):
      fix SMP ordering hole in fcntl_setlk() (CVE-2008-1669)

Greg Kroah-Hartman (1):
      Linux 2.6.25.2

