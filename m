Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936400Ab0B1SsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:48:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935375Ab0B1SsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:48:03 -0500
Date: Sun, 28 Feb 2010 20:44:40 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, kvm@vger.kernel.org, virtualization@lists.osdl.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       samudrala@us.ibm.com
Subject: [GIT PULL] vhost-net fixes for 2.6.34
Message-ID: <20100228184440.GA32692@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
The following tree, based on net-next-2.6, includes
patches fixing issues with vhost-net.
Please pull them for 2.6.34.

Thanks!

The following changes since commit 655ffee284dfcf9a24ac0343f3e5ee6db85b85c5:
  Jiri Pirko (1):
        wireless: convert to use netdev_for_each_mc_addr

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost

Michael S. Tsirkin (3):
      vhost: logging thinko fix
      vhost: initialize log eventfd context pointer
      vhost: fix get_user_pages_fast error handling

Sridhar Samudrala (1):
      vhost-net: restart tx poll on sk_sndbuf full

 drivers/vhost/net.c   |    6 +++++-
 drivers/vhost/vhost.c |   16 +++++++++++-----
 2 files changed, 16 insertions(+), 6 deletions(-)
