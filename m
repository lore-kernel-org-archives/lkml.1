Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYGaA0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYGaA0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759947AbYGaAYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:24:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:37808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763581AbYGaAYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:24:36 -0400
Date: Wed, 30 Jul 2008 16:59:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 54/62] ixgbe: remove device ID for unsupported device
Message-ID: <20080730235953.GB12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ixgbe-remove-device-id-for-unsupported-device.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit bb5d10ac8cc315d53306963001fe650d88a1cbb2 upstream

The ixgbe driver was untested with device ID 8086:10c8 but still advertises
support.  Currently if this device is present in the system when the driver
is loaded, the system will panic.
Remove this device ID until full support can be tested with available
hardware.  This patch is necessary for 2.6.24, 2.6.25 and 2.6.26

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ixgbe/ixgbe_main.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -70,8 +70,6 @@ static struct pci_device_id ixgbe_pci_tb
 	 board_82598 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82598AF_SINGLE_PORT),
 	 board_82598 },
-	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82598AT_DUAL_PORT),
-	 board_82598 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82598EB_CX4),
 	 board_82598 },
 

-- 
