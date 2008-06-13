Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbYFMQxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbYFMQxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 12:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYFMQx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 12:53:28 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46553 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYFMQx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:53:27 -0400
Message-Id: <20080613165209.507694130@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jun 2008 10:52:09 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 0/5] dev_printk() conversions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These convert some printks to dev_printks.  They are completely
independent of each other; I'm just posting them together because
it probably makes sense to review them together.

It'd be nice if a PCI person looked at pci_request_region().  To
me, it looks like it prints the wrong BAR number (it prints "bar + 1").

Bjorn
-- 
