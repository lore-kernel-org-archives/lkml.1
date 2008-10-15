Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYJOXds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYJOXds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYJOXdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:33:36 -0400
Received: from kroah.org ([198.145.64.141]:35172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752509AbYJOXdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:33:35 -0400
Date: Wed, 15 Oct 2008 16:29:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.1
Message-ID: <20081015232950.GA29323@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.1
kernel.

It contains one bugfix, disabling CONFIG_DYNAMIC_FTRACE that could cause
memory corruption.  This is believed to be the source of the recent
e1000 hardware b0rkage, and all users of the 2.6.27 kernel series are
encouraged to either disable the option, or to upgrade to this kernel
version which will force you to do so.

I'll also be replying to this message with a copy of the patch between
2.6.27 and 2.6.27.1

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile             |    2 +-
 kernel/trace/Kconfig |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (1):
      Linux 2.6.27.1

Steven Rostedt (1):
      disable CONFIG_DYNAMIC_FTRACE due to possible memory corruption on module unload

