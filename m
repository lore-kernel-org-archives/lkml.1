Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbYCFK40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbYCFK40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760499AbYCFKzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:55:50 -0500
Received: from mail.southpole.se ([193.12.106.18]:44084 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759983AbYCFKzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:55:49 -0500
From: Jonas Bonn <jonas@southpole.se>
To: jonas@southpole.se, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com
Subject: struct pci_device_id declaration cleanups
Date: Thu,  6 Mar 2008 11:55:38 +0100
Message-Id: <1204800947-21569-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This set of patches applies the macro DECLARE_PCI_DEVICE_TABLE to the 
declarations of struct pci_device_id in several network drivers.  The drivers
build cleanly with these patches (without any new warnings) on both x86 and 
PowerPC.

There are ~90 such cleanups in the /drivers/net tree alone (and ~350 in the
kernel overall); these patches are just a subset to avoid flooding the mailing 
list before getting feedback.

These 9 patches can also be pulled from the "net" branch of:

git://www.southpole.se/~jonas/git/linux.git

The remainder of the cleanups will be pushed out to my public tree once I 
know the reaction to this subset.

The diffstat for this subset is:

 drivers/net/cassini.c                |    2 +-
 drivers/net/e1000/e1000_main.c       |    2 +-
 drivers/net/e1000e/netdev.c          |    2 +-
 drivers/net/netxen/netxen_nic_main.c |    2 +-
 drivers/net/wan/farsync.c            |    2 +-
 drivers/net/wan/pc300_drv.c          |    2 +-
 drivers/net/wan/pc300too.c           |    2 +-
 drivers/net/wan/pci200syn.c          |    2 +-
 drivers/net/wan/wanxl.c              |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

/Jonas

