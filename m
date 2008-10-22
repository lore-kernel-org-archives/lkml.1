Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYJVDFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYJVDFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYJVDFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:05:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:35273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbYJVDF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:05:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,461,1220252400"; 
   d="scan'208";a="394538387"
Message-ID: <48FE9876.9040003@intel.com>
Date: Wed, 22 Oct 2008 11:05:26 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 12/15 v5] PCI: support the SR-IOV capability
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com> <20081021115308.GM3185@yzhao12-linux.sh.intel.com> <20081021165054.GA24795@kroah.com>
In-Reply-To: <20081021165054.GA24795@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Oct 21, 2008 at 07:53:08PM +0800, Yu Zhao wrote:
>> Support Single Root I/O Virtualization (SR-IOV) capability.
>>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Cc: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Grant Grundler <grundler@parisc-linux.org>
>> Cc: Alex Chiang <achiang@hp.com>
>> Cc: Matthew Wilcox <matthew@wil.cx>
>> Cc: Roland Dreier <rdreier@cisco.com>
>> Cc: Greg KH <greg@kroah.com>
>> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
>>

>> +#define iov_config_attr(field)                                               \
>> +static ssize_t field##_show(struct device *dev,                              \
>> +             struct device_attribute *attr, char *buf)               \
>> +{                                                                    \
>> +     struct pci_dev *pdev = to_pci_dev(dev);                         \
>> +     return sprintf(buf, "%d\n", pdev->iov->field);                  \
>> +}
>> +
>> +iov_config_attr(status);
>> +iov_config_attr(totalvfs);
>> +iov_config_attr(initialvfs);
>> +iov_config_attr(numvfs);
> 
> As you are adding new sysfs entries, can you also create the proper
> documentation in Documentation/ABI/ so that people can understand how to
> use them?  Yes, I see you added a stand-alone document, but putting it
> in the "standard" format is also necessary.

Thanks for reminding me about this. I used to update ABI doc in earlier 
versions, but somehow forgot to do this after several carry-forwards...

Will complete it in next version.

Regards,
Yu
