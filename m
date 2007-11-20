Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbXKTCCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbXKTCCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbXKTBu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:50:29 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2143 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465AbXKTBtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:45 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH 37/59] drivers/pci: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:29 -0800
Message-Id: <1195523331-15303-38-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-37-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
 <1195523331-15303-25-git-send-email-joe@perches.com>
 <1195523331-15303-26-git-send-email-joe@perches.com>
 <1195523331-15303-27-git-send-email-joe@perches.com>
 <1195523331-15303-28-git-send-email-joe@perches.com>
 <1195523331-15303-29-git-send-email-joe@perches.com>
 <1195523331-15303-30-git-send-email-joe@perches.com>
 <1195523331-15303-31-git-send-email-joe@perches.com>
 <1195523331-15303-32-git-send-email-joe@perches.com>
 <1195523331-15303-33-git-send-email-joe@perches.com>
 <1195523331-15303-34-git-send-email-joe@perches.com>
 <1195523331-15303-35-git-send-email-joe@perches.com>
 <1195523331-15303-36-git-send-email-joe@perches.com>
 <1195523331-15303-37-git-send-email-joe@perches.com>
Message-Id: <b56ad31ff9f8151583eaf50f5adb924b2e0ccb88.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pci/hotplug/pci_hotplug_core.c |    2 +-
 drivers/pci/probe.c                    |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 01c351c..b491a36 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -627,7 +627,7 @@ int pci_hp_register (struct hotplug_slot *slot)
 	if ((slot->info == NULL) || (slot->ops == NULL))
 		return -EINVAL;
 	if (slot->release == NULL) {
-		dbg("Why are you trying to register a hotplug slot"
+		dbg("Why are you trying to register a hotplug slot "
 		    "without a proper release function?\n");
 		return -EINVAL;
 	}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 463a5a9..bd6995f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -658,13 +658,13 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass
 		    (child->number > bus->subordinate) ||
 		    (child->number < bus->number) ||
 		    (child->subordinate < bus->number)) {
-			pr_debug("PCI: Bus #%02x (-#%02x) is %s"
+			pr_debug("PCI: Bus #%02x (-#%02x) is %s "
 				"hidden behind%s bridge #%02x (-#%02x)\n",
 				child->number, child->subordinate,
 				(bus->number > child->subordinate &&
 				 bus->subordinate < child->number) ?
-					"wholly " : " partially",
-				bus->self->transparent ? " transparent" : " ",
+					"wholly" : "partially",
+				bus->self->transparent ? " transparent" : "",
 				bus->number, bus->subordinate);
 		}
 		bus = bus->parent;
-- 
1.5.3.5.652.gf192c

