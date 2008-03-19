Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYCTD6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYCTD6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 23:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYCTD6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 23:58:11 -0400
Received: from fgwmail9.fujitsu.co.jp ([192.51.44.39]:42700 "EHLO
	fgwmail9.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYCTD6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 23:58:09 -0400
X-Greylist: delayed 14651 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 23:58:09 EDT
Message-ID: <47E07976.3040007@jp.fujitsu.com>
Date: Wed, 19 Mar 2008 11:24:54 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/3, v10] PCI, ACPI: Physical PCI slot objects
References: <20080318210539.GA30421@ldl.fc.hp.com> <20080319005535.GB424@parisc-linux.org>
In-Reply-To: <20080319005535.GB424@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Mar 18, 2008 at 03:05:39PM -0600, Alex Chiang wrote:
>> Also, v10 should fix the "pci_slot module changes the sysfs name"
>> issue that Kenji-san was seeing.
> 
> I thought we agreed that the current names are wrong, and we shouldn't
> consider this 'different name' an issue.
> 

I also think that the current names are wrong. But even if we fix the
slot name of shpchp/pciehp, it doesn't ensure that slot names are same
among pci_slot.ko and the other hotplug dirvers.

BTW, I'm planning to suggest the patch for shpchp/pciehp to use slot
number as a slot name (as they used to do), and add a module option
to use the combination of bus number and slot number as a slot name
as a workaround for problematic platforms.

Thanks,
Kenji Kaneshige

