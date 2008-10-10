Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYJJH0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYJJH0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYJJH0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:26:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:37136 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbYJJH0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:26:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,387,1220252400"; 
   d="scan'208";a="57784515"
Message-ID: <48EF0341.9040703@intel.com>
Date: Fri, 10 Oct 2008 15:24:49 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, "Zhao, Yu" <yu.zhao@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/6 v3] PCI: support SR-IOV capability
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F4@pdsmsx502.ccr.corp.intel.com> <20080930223851.GC13611@ldl.fc.hp.com>
In-Reply-To: <20080930223851.GC13611@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Do you want to emit a kobject_uevent here after success?
> 
> Alternatively, have you investigated making these virtual
> functions into real struct device's? You get a lot of sysfs stuff
> for free if you do so, including correct place in sysfs hierarchy
> and uevents, etc.

The virtual functions are rpresented by 'struct pci_dev', so same as 
real device, the standard sysfs entries are created by pci_bus_add_device.

> 
> My major complaints from last round (more documentation,
> shouldn't be a PCI hotplug driver) have been addressed. I'll let
> others comment about the other parts of your patch series.

Thanks, Alex.

> 
> Thanks.
> 
> /ac
> 

