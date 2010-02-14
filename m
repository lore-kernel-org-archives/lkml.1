Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab0BNLFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 06:05:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab0BNLFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 06:05:23 -0500
Date: Sun, 14 Feb 2010 13:00:51 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Michael S. Tsirkin" <mst@redhat.com>, Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tun: linux socket filter support
Message-ID: <20100214110051.GA30182@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tun module already support RX filtering, however,
this is limited to filtering by mac address.
For virtio host, we also need filtering by vlan.

Rather than adding this directly, it seems cleaner
to add generic socket filter support.



Michael S. Tsirkin (2):
  net: export attach/detach filter routines
  tun: socket filter support

 drivers/net/tun.c      |   26 ++++++++++++++++++++++++++
 include/linux/if_tun.h |    3 +++
 net/core/filter.c      |    2 ++
 3 files changed, 31 insertions(+), 0 deletions(-)
