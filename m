Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbYBTMzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbYBTMzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbYBTMyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:54:04 -0500
Received: from mail.southpole.se ([193.12.106.18]:42364 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbYBTMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:53:53 -0500
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: greg@kroah.com
Subject: pci_device_id cleanups
Date: Wed, 20 Feb 2008 13:53:36 +0100
Message-Id: <1203512031-14318-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The PCI_DEVICE_TABLE patch I sent earlier doesn't necessarily make much sense by itself... here is a set of patches that apply this macro, in turn moving a lot of this data into __devinitconst which is discardable in certain situations.  Hopefully the benefit of this approach is a bit clearer now.

 drivers/net/3c59x.c               |    2 +-
 drivers/net/amd8111e.c            |    2 +-
 drivers/net/arcnet/com20020-pci.c |    2 +-
 drivers/net/defxx.c               |    2 +-
 drivers/net/hamachi.c             |    2 +-
 drivers/net/niu.c                 |    2 +-
 drivers/net/pasemi_mac.c          |    2 +-
 drivers/net/sk98lin/skge.c        |    2 +-
 drivers/net/skfp/skfddi.c         |    2 +-
 drivers/net/starfire.c            |    2 +-
 drivers/net/sunhme.c              |    2 +-
 drivers/net/tlan.c                |    2 +-
 drivers/net/wan/dscc4.c           |    2 +-
 drivers/net/wan/lmc/lmc_main.c    |    2 +-
 include/linux/pci.h               |    9 +++++++++
 15 files changed, 23 insertions(+), 14 deletions(-)


