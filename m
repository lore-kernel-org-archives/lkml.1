Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418Ab0AJOFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0AJOFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359Ab0AJOE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:04:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56658 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0AJOEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:04:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>
Subject: [PATCH 0/9] PCI run-time PM support (rev. 3)
Date: Sun, 10 Jan 2010 14:31:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001101431.38630.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following (updated) series of patches provides basic run-time power
management support for PCI devices through ACPI and/or the native PCIe
PME.

[1/9] - Add function for checking PME status of devices

[2/9] - PCIe PME root port service driver

[3/9] - "Don't use MSIs for PME signaling" switch for PCIe
 
[4/9] - ACPI GPE refcounting, from Matthew Garrett
 
[5/9] - ACPI drivers support for GPE refcounting, from Matthew Garrett
 
[6/9] - ACPI removal of the old GPE API, from Matthew Garrett
 
[7/9] - ACPI add fields for handling run-wake devices

[8/9] - PCI / ACPI platform support for run-time power management

[9/9] - Runtime PM callbacks for the PCI bus type

Bob, patches [4/9] - [6/9] from Matthew introduce GPE refconting which is
necessary for the PCI run-time power management.  If I remeber correctly, you
saw these patches some time ago, but we need your ack before they can go
upstream.  Please let us know if there's anything to fix in these patches.

Thanks,
Rafael

