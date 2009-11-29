Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZK2Pp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZK2Pp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZK2Pp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:45:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36404 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZK2Ppy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:45:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/12] PCI run-time PM support (updated)
Date: Sun, 29 Nov 2009 16:32:44 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl>
In-Reply-To: <200911160047.46299.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911291632.44763.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
The following (updated) series of patches provides preliminary run-time power
management support for PCI devices through ACPI and/or the native PCIe PME.

Some patches have been modified since the previous iteration and two new
patches have been added.  Also, I've tested this patchset with the native PCIe
PME mechanism using the r8169 driver on the MSI Wind U-100 (see the last patch
for details).

[1/12] - Add flag for marking devices capable of generating wake-up events at run time
 
[2/12] - Add function for checking PME status of devices
 
[3/12] - Modify wake-up enable propagation so that it's done for PCIe devices too
 
[4/12] - PCIe PME root port service driver

[5/12][New] - "Don't use MSIs for PME signaling" switch for PCIe
 
[6/12] - ACPI GPE refcounting, from Matthew
 
[7/12] - ACPI drivers support for GPE refcounting, from Matthew
 
[8/12] - ACPI removal of the old GPE API, from Matthew
 
[9/12] - ACPI add fields for handling run-wake devices
 
[10/12] - PCI ACPI platform support for run-time power management

[11/12] - Runtime PM callbacks for the PCI bus type

[12/12] - Runtime PM support for r8169 (experimental)

If there are no objections, I think the patches [1-11/12] are ready for merging
at this point.

Thanks,
Rafael

