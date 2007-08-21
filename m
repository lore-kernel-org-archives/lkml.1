Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbXHUQ00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbXHUQ00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 12:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbXHUQ0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 12:26:18 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33035 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbXHUQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 12:26:17 -0400
Date: Tue, 21 Aug 2007 09:31:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-git3 make warnings
Message-Id: <20070821093103.3c097d4a.randy.dunlap@oracle.com>
In-Reply-To: <20070821132038.GA22254@ff.dom.local>
References: <20070821132038.GA22254@ff.dom.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007 15:20:38 +0200 Jarek Poplawski wrote:

> Here are some more of, probably well-known, warnings with attached
> testing-only .config.
> 
> Regards,
> Jarek P.
> 
> 
> sed: -e expression #1, char 154: Unknown option to 's'
> drivers/acpi/ec.c: In function `acpi_ec_ecdt_probe':
> drivers/acpi/ec.c:873: warning: passing arg 1 of `acpi_get_devices' discards qualifiers from pointer target type
> drivers/pci/search.c: In function `pci_find_slot':
> drivers/pci/search.c:99: warning: `pci_find_device' is deprecated (declared at include/linux/pci.h:480)
> drivers/pci/search.c: At top level:
> drivers/pci/search.c:437: warning: `pci_find_device' is deprecated (declared at drivers/pci/search.c:244)
> drivers/pci/search.c:437: warning: `pci_find_device' is deprecated (declared at drivers/pci/search.c:244)
> drivers/pci/search.c:438: warning: `pci_find_slot' is deprecated (declared at drivers/pci/search.c:96)
> drivers/pci/search.c:438: warning: `pci_find_slot' is deprecated (declared at drivers/pci/search.c:96)
> drivers/pci/msi.c:686: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
> drivers/pci/msi.c:698: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
> drivers/pci/msi.c:718: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior
> In file included from drivers/usb/host/ohci-hcd.c:859:
> drivers/usb/host/ohci-pci.c: In function `ohci_pci_start':
> drivers/usb/host/ohci-pci.c:202: warning: unused variable `pdev'
> Root device is (8, 1)
> Setup is 11036 bytes (padded to 11264 bytes).
> System is 2428 kB

What gcc version?  I don't get the arch_ warnings in drivers/pci/msi.c.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
