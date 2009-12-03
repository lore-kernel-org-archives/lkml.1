Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbZLCRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbZLCRxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZLCRxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:53:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbZLCRxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:53:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S . Miller \"" <davem@davemloft.net>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>,
       "Fischer, Anna" <anna.fischer@hp.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Patrick Mullaney <pmullaney@novell.com>
Subject: [RFC 0/2] macvtap, second try
Date: Thu,  3 Dec 2009 18:51:58 +0100
Message-Id: <1259862720-28432-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
X-Provags-ID: V01U2FsdGVkX19pr+4f7hAWHdAVXaevU21xf5R2a3eL+ysQOk8
 r7scQXrjekE4ehnwPa/Dx1J6iOGtSpvYz4zXFTpBKigTQYEJEl
 5n0eixsZk1KaEs2bwIU1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not get this ready for the merge window, but people asked what
the status of this is so I'm posting it now to solicit feedback.

The first patch just adds some hooks into macvlan.c and is less
invasive than the previous version. That part should be fine
and I'd like this to get merged into macvlan for 2.6.33 if people
agree that the approach is right.

The second patch adds the driver using it and is not ready for
integration unfortunately, but maybe it could get into staging
anyway. Please look at that patch carefully and provide feedback.

	Arnd <><
---

Arnd Bergmann (1):
  macvlan: add tap device backend

Patrick Mullaney (1):
  macvlan: Allow plugging in additional backends

 drivers/net/Kconfig        |   12 +
 drivers/net/Makefile       |    1 +
 drivers/net/macvlan.c      |  113 ++++-----
 drivers/net/macvtap.c      |  560 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/if_macvlan.h |   71 ++++++
 5 files changed, 693 insertions(+), 64 deletions(-)
 create mode 100644 drivers/net/macvtap.c

