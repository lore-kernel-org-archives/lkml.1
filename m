Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYGGWsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYGGWsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYGGWse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:48:34 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35999 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbYGGWsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:48:33 -0400
Message-Id: <20080707224303.303748495@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 16:43:03 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 0/2] dev_printk() conversions, v3
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These convert some printks to dev_printks.

v3 changes:

    - refresh for newer tree (these were generated against 2.6.26-rc8-mm1)
    - doesn't include the ACPI and PCI changes already in linux-next
    - new patch replaces non-device-specific DBG() with pr_debug() and
      removes DBG()

v2 changes:

    - print "PCI INT A" instead of "PCI INTA#"
    - in pci_request_region(), print "bar", not "bar + 1"

Bjorn
-- 
