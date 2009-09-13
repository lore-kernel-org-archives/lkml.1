Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZIMVZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZIMVZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 17:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZIMVYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 17:24:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50572 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbZIMVYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 17:24:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/4] PCI / ACPI PM: Run-time PM, PME handling and PCI bus type callbacks
Date: Sun, 13 Sep 2009 23:20:04 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Shaohua Li <shaohua.li@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909132320.05077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches implement experimental run-time PM support for PCI bus
type.

[1/4] - add PME status checking/clearing
[2/4] - Implement native PCIe PME driver for root ports
[3/4] - Add ACPI platform support for PCI PME signaling
[4/4] - Implement run-time PM callbacks for the PCI bus type

All of this is highly theoretical, because I didn't have the time to add
runtime PM callbacks to any drivers I can test, but at least the patchset
compiles and doesn't break things outright.

Comments welcome.

Thanks,
Rafael

