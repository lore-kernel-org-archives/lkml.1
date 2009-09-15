Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbZIOTHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbZIOTHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZIOTHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:07:21 -0400
Received: from kroah.org ([198.145.64.141]:35804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZIOTHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:07:20 -0400
Date: Tue, 15 Sep 2009 11:07:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.34
Message-ID: <20090915180703.GA32060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.34 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.33 and 2.6.27.34

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                 |    2 +-
 drivers/net/e100.c       |    2 +-
 fs/jffs2/wbuf.c          |   10 ++++++++++
 mm/slub.c                |    4 ++--
 net/core/net_namespace.c |    2 +-
 5 files changed, 15 insertions(+), 5 deletions(-)


Eric Dumazet (2):
      net: net_assign_generic() fix
      slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU

Greg Kroah-Hartman (1):
      Linux 2.6.27.34

Krzysztof Hałasa (1):
      E100: fix interaction with swiotlb on X86.

Massimo Cirillo (1):
      JFFS2: add missing verify buffer allocation/deallocation

