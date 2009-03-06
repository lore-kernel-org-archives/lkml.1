Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZCFVrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZCFVrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZCFVq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:46:57 -0500
Received: from xenotime.net ([72.52.64.118]:55601 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752069AbZCFVq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:46:56 -0500
Message-ID: <49B19A31.6070205@xenotime.net>
Date: Fri, 06 Mar 2009 13:48:33 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 4/7] PCI: add SR-IOV API for Physical Function driver
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-5-git-send-email-yu.zhao@intel.com> <20090306203717.GG25995@parisc-linux.org>
In-Reply-To: <20090306203717.GG25995@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 02:54:45PM +0800, Yu Zhao wrote:
> 
>> +	if (nres != iov->nres) {
>> +		dev_err(&dev->dev, "no enough MMIO for SR-IOV\n");
>> +		return -ENOMEM;
>> +	}

		"not enough MMIO BARs for SR-IOV"
	or
		"not enough MMIO resources for SR-IOV"
	or
		"too few MMIO BARs for SR-IOV"
?

> Randy, can you help us out with better wording here?
> 
>> +		dev_err(&dev->dev, "no enough bus range for SR-IOV\n");
> 
> and here.

		"SR-IOV: bus number too large"
	or
		"SR-IOV: bus number out of range"
	or
		"SR-IOV: cannot allocate valid bus number"
?

>> +	if (iov->link != dev->devfn) {
>> +		rc = -ENODEV;
>> +		list_for_each_entry(link, &dev->bus->devices, bus_list) {
>> +			if (link->sriov && link->devfn == iov->link)
>> +				rc = sysfs_create_link(&iov->dev.kobj,
>> +						&link->dev.kobj, "dep_link");

