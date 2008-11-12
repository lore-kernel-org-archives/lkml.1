Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYKLVyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYKLVyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYKLVy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:54:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbYKLVy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:54:28 -0500
Date: Wed, 12 Nov 2008 13:54:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, djwong@us.ibm.com
Subject: Re: mmotm 2008-11-10-14-54 uploaded (i5k_amb)
Message-Id: <20081112135425.7545be3e.akpm@linux-foundation.org>
In-Reply-To: <20081112132640.1c7ac924.rdunlap@xenotime.net>
References: <200811102254.mAAMsTU5029697@imap1.linux-foundation.org>
	<20081112132640.1c7ac924.rdunlap@xenotime.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 13:26:40 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> 
> drivers/hwmon/i5K_amb.c contains a few duplicated lines, causing:
> 
> mmotm-2008-1112-1148/drivers/hwmon/i5k_amb.c:500: error: redefinition of 'i5k_amb_ids'
> mmotm-2008-1112-1148/drivers/hwmon/i5k_amb.c:493: error: previous definition of 'i5k_amb_ids' was here
> 
> 
> 
> static struct pci_device_id i5k_amb_ids[] __devinitdata = {
> 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
> 	{ 0, }
> };
> MODULE_DEVICE_TABLE(pci, i5k_amb_ids);
> 
> static struct pci_device_id i5k_amb_ids[] __devinitdata = {
> 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
> 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
> 	{ 0, },
> };
> 
> MODULE_DEVICE_TABLE(pci, i5k_amb_ids);

ok, i5k_amb-load-automatically-on-all-5000-5400-chipsets.patch got
changed then merged via the i2c tree.

