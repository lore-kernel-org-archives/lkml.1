Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbZAWXZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbZAWXZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759056AbZAWXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:24:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43489 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979AbZAWXYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:24:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/2] PCI/PCIe port driver: Fix allocation of interrupts
Date: Sat, 24 Jan 2009 00:19:35 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240019.36794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches fix the allocation of interrupts in the PCIe port
driver, which is currently broken with respect to MSI-X.

The first patch introduces a new function returning the size of a device's
MSI-X table, which is used in the second patch.

The second one is the actual fix.

Please consider for applying.

Thanks,
Rafael

