Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXDZH1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXDZH1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXDZH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:27:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48610 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbXDZH1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:27:30 -0400
Date: Thu, 26 Apr 2007 00:24:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.20.9
Message-ID: <20070426072441.GA5515@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.9 kernel.
This release has a security bugfix so any users of kernels older than
2.6.20.8 that have ipv6 enabled are highly encouraged to upgrade as soon
as possible.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.20.8 and 2.6.20.9.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h

--------
 Documentation/networking/ip-sysctl.txt |    9 +++++++
 Makefile                               |    2 -
 include/linux/ipv6.h                   |    3 ++
 include/linux/sysctl.h                 |    1 
 net/ipv6/addrconf.c                    |   11 +++++++++
 net/ipv6/exthdrs.c                     |   40 ++++++++++++++++++++++++++++-----
 6 files changed, 59 insertions(+), 7 deletions(-)

Summary of changes from v2.6.20.8 to v2.6.20.9
==============================================

Greg Kroah-Hartman (1):
      Linux 2.6.20.9

YOSHIFUJI Hideaki (1):
      IPV6: Disallow RH0 by default.
