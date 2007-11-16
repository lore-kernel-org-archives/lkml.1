Return-Path: <linux-kernel-owner+w=401wt.eu-S934251AbXKPS4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbXKPS4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXKPSzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:55:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46941 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765703AbXKPSzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:55:32 -0500
Date: Fri, 16 Nov 2007 10:52:19 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.13
Message-ID: <20071116185219.GA10141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.13 kernel.
If fixes some security issues and any user of the 2.6.22 series is
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.12 and 2.6.22.13

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile             |    2 +-
 kernel/exit.c        |    3 +--
 net/ipv4/tcp_input.c |    5 +++++
 3 files changed, 7 insertions(+), 3 deletions(-)

Summary of changes from v2.6.22.12 to v2.6.22.13
================================================

Greg Kroah-Hartman (1):
      Linux 2.6.22.13

Ilpo Järvinen (1):
      TCP: Make sure write_queue_from does not begin with NULL ptr (CVE-2007-5501)

Roland McGrath (1):
      wait_task_stopped: Check p->exit_state instead of TASK_TRACED (CVE-2007-5500)

