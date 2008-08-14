Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYHNViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYHNViW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYHNVh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:37:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56442 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYHNVh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:37:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: netdev@vger.kernel.org
Subject: [PATCH 0/3] Adapt three network drivers to the reworked PCI PM
Date: Thu, 14 Aug 2008 23:35:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Stephen Hemminger <stephen.hemminger@vyatta.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808142335.56644.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After the PCI PM core code has been updated, PCI network drivers (especially
those using pci_enable_wake() for setting up WOL) should be adapted to it.

This series of patches modifies three drivers, skge, sky2 and e100, for this
purpose.

[Note for Andrew: Patch 1/3 has been in -mm for some time, but the present one
has a better changelog (IMO).]

Please consider for applying.

Thanks,
Rafael

