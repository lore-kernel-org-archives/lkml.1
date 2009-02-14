Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZBNAa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZBNAa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZBNAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:30:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:30574 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbZBNAaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:30:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,203,1233561600"; 
   d="scan'208";a="386726947"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: ACPI hotplug panic with current git head
Date: Fri, 13 Feb 2009 16:30:03 -0800
User-Agent: KMail/1.9.10
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Len Brown <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>
References: <1231604250.3642.33.camel@localhost.localdomain> <497D1BD7.9000609@jp.fujitsu.com> <498045D1.60005@jp.fujitsu.com>
In-Reply-To: <498045D1.60005@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131630.04858.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 28, 2009 3:47 am Kenji Kaneshige wrote:
> I made several patches to fix the wrong assumption described
> above. It is very difficult for me to check all the code that
> refers pci_bus->self. So I checked include/linux/pci-acpi.h and
> the code under drivers/pci/ only. And I made patches for the code
> like below:
>
>  - The code that clearly chooses host bridge operation or
>    PCI-to-PCI bridge operation based on pci_bus->self.
>
>  - The code that might cause endless loop if pci_bus->self is
>    not NULL on the PCI root bus.

Kenji-san, can you re-send these to my private mail so I can apply them?  
(Outlook/Exchange can't let plain text through without molesting it for some 
reason.)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
