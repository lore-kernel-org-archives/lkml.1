Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbXIYGTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbXIYGTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXIYGTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:19:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42150 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXIYGTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:19:00 -0400
Date: Mon, 24 Sep 2007 23:21:15 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.8
Message-ID: <20070925062115.GA18444@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.8 kernel.
It contains a single security bugfix for the the sound subsystem.  There
is potential for local privilege escalation, so all users are certainly
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.7 and 2.6.22.8

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile              |    2 -
 sound/core/memalloc.c |   68 ++++++++++++++++++++++++++++----------------------
 2 files changed, 40 insertions(+), 30 deletions(-)

Summary of changes from v2.6.22.7 to v2.6.22.8
==============================================

Greg Kroah-Hartman (1):
      Linux 2.6.22.8

Takashi Iwai (1):
      Convert snd-page-alloc proc file to use seq_file (CVE-2007-4571)

