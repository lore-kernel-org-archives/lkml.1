Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXGJUH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXGJUH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXGJUHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:07:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41646 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbXGJUHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:07:19 -0400
Date: Tue, 10 Jul 2007 13:06:37 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.1
Message-ID: <20070710200637.GA5881@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.1 kernel.
It contains a security fix for SCTP that somehow forgot to be added to
the 2.6.22 kernel (was already released in the 2.6.21.y releases).
Thanks to Patrick McHardy for noticing the mistake.

I'll also be replying to this message with a copy of the patch between
2.6.22 and 2.6.22.1

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

---------

 Makefile                                |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Summary of changes from v2.6.22 to v2.6.22.1
============================================

Greg Kroah-Hartman (1):
      Linux 2.6.22.1

Patrick McHardy (1):
      NETFILTER: {ip, nf}_conntrack_sctp: fix remotely triggerable NULL ptr dereference (CVE-2007-2876)

