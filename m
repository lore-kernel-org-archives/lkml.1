Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0BQWpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:45:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46312 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab0BQWpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:45:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>
Subject: [PATCH 0/8] PCI run-time PM support (rev. 4)
Date: Wed, 17 Feb 2010 23:35:47 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002172335.47703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following (updated) series of patches provides basic run-time power
management support for PCI devices through ACPI and/or the native PCIe
PME.

Patches [1/8] and [3/8] are unchanged, the other patches have been modified to
address the reviewers' comments and/or to fix reported bugs.

[1/8] - Add function for checking PME status of devices

[2/8][Updated] - PCIe PME root port service driver

[3/8] - "Don't use MSIs for PME signaling" switch for PCIe
 
[4/8][New] - ACPI GPE refcounting, based on 3 patches from Matthew Garrett
 
[5/8][Updated] - ACPI, add fields for handling run-wake devices

[6/8][New] - ACPI, make it possible to use more than 1 notify handler per node

[7/8][Updated] - PCI / ACPI platform support for run-time power management

[8/8] - Runtime PM callbacks for the PCI bus type

Bob, Len, patches [4/8] and [6/8] are vitally important for this feature, but
they cannot be merged without your approval.  Please let me know if you have
any objections to these patches.

Thanks,
Rafael

