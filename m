Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYF0Ot5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYF0Ot5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759762AbYF0OtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:49:22 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:10938 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbYF0OtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:49:19 -0400
Message-Id: <20080627144538.743154341@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 08:45:38 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 0/6] dev_printk() conversions, v2
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These convert some printks to dev_printks.

v2 changes:

    - print "PCI INT A" instead of "PCI INTA#"
    - in pci_request_region(), print "bar", not "bar + 1"

Bjorn
-- 
