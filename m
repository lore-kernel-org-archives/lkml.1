Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZKOX6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZKOX6s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 18:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZKOX6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 18:58:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZKOX6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 18:58:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/10] PCI run-time PM support
Date: Mon, 16 Nov 2009 00:47:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
MIME-Version: 1.0
Message-Id: <200911160047.46299.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches provides run-time power management support
through ACPI and the native PCIe PME.

[1/10] - Add flag for marking devices capable of generating wake-up events at run time

[2/10] - Add function for checking PME status of devices

[3/10] - Modify wake-up enable propagation so that it's done for PCIe devices too

[4/10] - PCIe PME root port service driver

[5/10] - ACPI GPE refcounting from Matthew

[6/10] - ACPI drivers support for GPE refcounting from Matthew

[7/10] - ACPI removal of the old GPE API from Matthew

[8/10] - ACPI add fields for handling run-wake devices

[9/10] - PCI ACPI platform support for run-time power management

[10/10] - Runtime PM callbacks for the PCI bus type

Comments welcome.

Best,
Rafael

