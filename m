Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0BWRB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:01:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab0BWRB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:01:27 -0500
Date: Tue, 23 Feb 2010 18:57:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       gleb@redhat.com, herbert.xu@redhat.com, quintela@redhat.com
Subject: [PATCH 0/3] vhost: logging fixes
Message-ID: <cover.1266943453.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches on top of net-next fix issues related to write
logging in vhost. This fixes all known to me logging issues, migration
now works for me while under stress in both TX and RX directions.
Rusty's going on vacation, I am guessing he won't have time to review
this: Gleb, Juan, Herbert, could one of you review this patchset please?

There's also the send queue full issue reported by
Sridhar Samudrala which I'm testing various fixes for,
that patch is contained to vhost/net though,
so there's no conflict, patch will be posted separately.


Michael S. Tsirkin (3):
  vhost: logging thinko fix
  vhost: initialize log eventfd context pointer
  vhost: fix get_user_pages_fast error handling

 drivers/vhost/vhost.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)
