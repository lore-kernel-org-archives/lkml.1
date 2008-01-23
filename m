Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYAWASX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYAWASX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYAWASK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:18:10 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43504 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYAWASI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:18:08 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 0/4] ACPI fixes for PCIe AER
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, gregkh@suse.de,
       matthew@wil.cx, tom.l.nguyen@intel.com, linux-acpi@vger.kernel.org
Date: Tue, 22 Jan 2008 17:18:07 -0700
Message-ID: <20080123001807.28190.32648.stgit@bluto.andrew>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch series fixes some bugs in how Linux determines
whether PCIe Advance Error Reporting (AER) is supported on a platform.  It
is currently broken on at least HP IA-64 systems.

 - PCI: Run ACPI _OSC method on root bridges only
 - ACPI: Check for any matching CID when walking namespace.
 - PCI ACPI: AER driver should only register PCIe devices with _OSC.
 - PCI ACPI: Added a function to register _OSC with only PCIe devices.


These patches apply to gregkh's patch tree:

      git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/patches


-- 
Andrew Patterson
