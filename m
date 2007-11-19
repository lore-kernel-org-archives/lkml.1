Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbXKSRoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbXKSRoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 12:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXKSRop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 12:44:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:56300 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbXKSRoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:44:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,437,1188802800"; 
   d="scan'208";a="210720744"
Date: Mon, 19 Nov 2007 09:43:07 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, achiang@hp.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071119094307.517411a2@appleyard>
In-Reply-To: <20071117182954.GA25003@ldl.fc.hp.com>
References: <20071117182954.GA25003@ldl.fc.hp.com>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 11:29:54 -0700
Alex Chiang <achiang@hp.com> wrote:

> I have done quite a bit more testing, and verified that this
> series plays nicely with acpiphp during all stages of the series.
> Notably, you can modprobe/rmmod acpiphp repeatedly no matter
> where you are in the series, and no matter whether you have
> CONFIG_ACPI_PCI_SLOT turned on. The correct entries in
> /sys/bus/pci/slots/ will appear and disappear, and we correctly
> register/deregister ACPI slots with the pci_hp core. 

Hi Alex,
How does this patch play with non-acpi based hotplug such as the pciehp
driver or the shpchp driver for example?

Thanks,
Kristen
