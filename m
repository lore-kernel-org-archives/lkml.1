Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbXKPSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbXKPSlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXKPSlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:41:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52840 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbXKPSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:41:06 -0500
Date: Fri, 16 Nov 2007 10:37:52 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.8
Message-ID: <20071116183752.GA9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.8 kernel.
It contains a few serious security fixes, as well as a raft of other
bugfixes and stuff from the last 2.6.23.1 kernel release.

Wait, what happened to versions 2.6.23.2 - 7 you might ask?  Well, they
too are released, and I'll be responding to this message with those
individual changelogs and diffs.  They corrispond to the different patch
groups that I sent out for review of the stable tree in order to handle
the huge number of overall patches.  This way, if problems occur, it
will be easier for people to track down where the regression might have
happened.

I'll also be replying to this message with a copy of the patch between
2.6.23.7 and 2.6.23.8

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile             |    2 +-
 kernel/exit.c        |    3 +--
 net/ipv4/tcp_input.c |    5 +++++
 3 files changed, 7 insertions(+), 3 deletions(-)

Summary of changes from v2.6.23.7 to v2.6.23.8
==============================================

Greg Kroah-Hartman (1):
      Linux 2.6.23.8

Ilpo Järvinen (1):
      TCP: Make sure write_queue_from does not begin with NULL ptr (CVE-2007-5501)

Roland McGrath (1):
      wait_task_stopped: Check p->exit_state instead of TASK_TRACED (CVE-2007-5500)

