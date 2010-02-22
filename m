Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0BVXJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:09:35 -0500
Received: from mail.pxnet.com ([195.227.45.7]:57810 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab0BVXJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:09:33 -0500
Subject: [PATCH 0/4] gigaset: patches for 2.6.34
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100221-patch-gigaset-00.tilman@imap.cc>
Date: Tue, 23 Feb 2010 00:08:21 +0100 (CET)
X-Spam-Score: -2.186 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten, David,

following are four patches to the Gigaset driver I'd like you to
forward for merging into kernel release 2.6.34.

Thanks,
Tilman

Andy Shevchenko (1):
  isdn: remove ishexdigit() in regard to isxdigit()

Tilman Schmidt (3):
  gigaset: small documentation improvement
  bas_gigaset: collapse CR/LF at end of AT response
  gigaset: reduce syslog clutter

 Documentation/isdn/README.gigaset  |   10 ++---
 drivers/isdn/gigaset/asyncdata.c   |    6 ++-
 drivers/isdn/gigaset/bas-gigaset.c |   18 +++-------
 drivers/isdn/gigaset/capi.c        |   31 ++----------------
 drivers/isdn/gigaset/common.c      |   49 +++++++++++-----------------
 drivers/isdn/gigaset/ev-layer.c    |   63 ++++++++++++++++++-------------------
 drivers/isdn/gigaset/gigaset.h     |   11 ++----
 drivers/isdn/gigaset/i4l.c         |   52 +++---------------------------
 drivers/isdn/gigaset/interface.c   |   12 ++-----
 drivers/isdn/gigaset/isocdata.c    |   44 ++++++++++++++++++-------
 drivers/isdn/gigaset/proc.c        |    2 -
 drivers/isdn/gigaset/usb-gigaset.c |    2 -
